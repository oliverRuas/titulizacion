/*
oliver
*/

package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"math"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric-protos-go/ledger/queryresult"
)

//añadir todos los decimales
const precio_kwh float64 = 0.123454689

//Defino e inicializo variables que usaré más adelante, que son fijas y que se aceptaran con la aprobación del chaincode
//Años que va a durar el contrato
const years int = 10

//periodos por año
const months int = 12

//número de contratos

const numero_contratos int = 500

//cada cuanto tiempo va a pagar cupon el bono
const tiempo_cupon int = 12

//cantidad de bonos emitida
const cantidad_bonos int = 5000

// //valor de emisión del bono
// const valor_emision float64 = 926.46

//cupon que va a pagar el bono
const cupon float64 = 4

//valor de emision del bono
const originalvalue float64 = 926.46

//principal del bono que va a pagar a vencimiento
const principal float64 = 1000

// //se puede quitar
// var periodo int

//defino esta estructura que implementará la lógica del modulo Contract del paquete contractapi
type SmartContract struct {
	contractapi.Contract
	afterTransaction  interface{}
	beforeTransaction interface{}
}

type CustomTransactionContextInterface interface {
	contractapi.TransactionContextInterface
}

// type SettableTransactionContextInterface interface {
// 	// SetStub should provide a way to pass the stub from a chaincode transaction
// 	// call to the transaction context so that it can be used by contract functions.
// 	// This is called by Init/Invoke with the stub passed.
// 	SetStub(shim.ChaincodeStubInterface)
// 	// SetClientIdentity should provide a way to pass the client identity from a chaincode
// 	// transaction call to the transaction context so that it can be used by contract functions.
// 	// This is called by Init/Invoke with the stub passed.
// 	SetClientIdentity(ci cid.ClientIdentity)
// }

//Defino una estructura de un activo llamado PPA que tiene estas
//estas propiedades (ojo, atributos de una struct en go con primera
//letra en Mayusc) y definimos la representacion json de estos atributos
//que es como se va a guardar en el ledger. Al final los pagos y la energia consumida se van a guardar en un vector, para evitar llenar
//el world state de 500*120 docs, ya que estariamos desaprovechando la caracteristica de guardar la versión actual de la blockchain
//la version actual es una version que contiene el pago actual, no interesarian los pagos anteriores salvo para consulta y para emitir los tokens.
type PPA struct {
	DocType  string                  `json:"docType"`
	Client   string                  `json:"client"`
	Energy   [years * months]float64 `json:"energy"`
	Default  bool                    `json:"default"`
	Payments [years * months]float64 `json:"payments"`
	Period   int                     `json:"periodo"`
	Fecha    Datos
}

//estructura para la fecha que se añade a cada pago
type Datos struct {
	Day   int
	Month time.Month
	Year  int
}

//estructura que ya no se usa
type Pagos struct {
	Doctype string  `json:"docType"`
	Total   float64 `json:"total"`
	Owner   string  `json:"propietario"`
}

//estructura que guarda los pagos agrupados de cada tiempo_cupon. Basicamente es un doc que informa de que
//se ha emitido un UTXOToken con esa cantidad
type Pool struct {
	Doctype string  `json:"docType"`
	Total   float64 `json:"total"`
	Balance float64 `json:"balance"`
	Client  string  `json:"cliente"`
	State   string  `json:"estado"`
}

//Estructura que se usará para obtener las ID de los clients de la organizacion farmer
type FarmerID struct {
	Doctype   string `json:"docType"`
	Identidad string `json:"identidad"`
}

// //estructura que se usará para calcular el total de los payments del modelo del SPV. Ya no se usa
// type ValorTotal struct {
// 	Doctype string  `json:"docType"`
// 	Total   float64 `json:"total"`
// }

//estructura que se usa para obtener aquellos ppa cuyo atributo default sea falso
type PagosImpagos struct {
	Payments [years * months]float64 `json:"pagos"`
	Default  bool                    `json:"impago"`
}

//estructura del bono
type UTXOBond struct {
	Key        string  `json:"utxo_key"`
	Issuer     string  `json:"issuer"`
	Investor   string  `json:"owner"`
	Amount     int     `json:"amount"`
	CouponRate float64 `json:"couponrate"`
	// Value             string  `json:"value"` // Expected payout
	MaturityDate      Datos   `json:"maturitydate"`
	AmountPaid        float64 `json:"amountpaid"`
	OriginalValue     float64 `json:"originalvalue"`
	MonthlyPayout     float64 `json:"monthlypayout"`
	RemainingPayments int     `json:"remainingpayments"`
}

//estructura de los pagos al inversor
type UTXOToken struct {
	Key      string `json:"utxo_key"`
	Issuer   string `json:"issuer"`
	Investor string `json:"owner"`
	Amount   int    `json:"amount"`
}

//estructura de la petición que un inversor o alguien en el mercado secundario puede emitir
//para adquirir un bono
type Request struct {
	Doctype    string `json:"docType"`
	Requester  string `json:"bonista"`
	Amount     int    `json:"cantidad"`
	KeyRequest string `json:"clave"`
	//	RequestedAt	*time.Location	`json:"peticion"`
}

type ForSale struct {
	Doctype string  `json:"docType"`
	Key     string  `json:"clave"`
	Owner   string  `json:"bonista"`
	Amount  int     `json:"cantidad"`
	Price   float64 `json:"precio"`
	IDBond  string  `json:"bond id"`
	//	RequestedAt	*time.Location	`json:"peticion"`
}

//Segun esta estructura es como se guarda en el ledger
type State struct {
	DocType string `json:"docType"`
	Valor   UTXOBond
}

//Segun esta estructura es como se guarda en el ledger
type AnotherState struct {
	DocType string `json:"docType"`
	Valor   UTXOToken
}

//Estructura que se usa unicamente para obtener informacion de los bonos que se han emitido
//en esta titulizacion
type Bond struct {
	Doctype      string  `json:"docType"`
	ValorEmision float64 `json:"valorEmision"`
	Cupon        float64 `json:"cupon"`
	Vencimiento  int     `json:"vencimiento"`
	TiempoPagos  int     `json:"tiempoPagos"`
}

//Eventos que se distribuiran despues de cada transaccion. No todas las transacciones devuelven eventos.
var EventNames = map[string]string{
	"IssueBond":             "Bonds issued",
	"Transfer":              "Transfered",
	"WritePayments":         "Payments",
	"IssueUtxo":             "UTXO issued",
	"TransferUTXO":          "UTXO transfered",
	"TransferPaymentsToSpv": "UTXO transfered to SPV",
	"RequestBond":           "Bond requested",
	"Redeem":                "Redeemed",
	"RegisteringFarmers":    "Farmer registered",
}

//carga util (el conjunto de datos transmitidos que es en realidad el mensaje enviado) que se envia en
//una transaccion de emision
type MintedPayload struct {
	Minter   string `json:"minter"`
	UTXOID   string `json:"UtxoId"`
	Receiver string `json:"receiver"`
	Code     string `json:"utxoCode"`
}

// carga util que se envia en una transaccion de registro de identidad
type RegisterIdentityPayload struct {
	UserID string `json:"id"`
	Code   string `json:"code"`
}

//carga util que se envia en una transaccion de pago de los agricultores
type WritePaymentsPayload struct {
	Client   string  `json:"client"`
	Payments float64 `json:"payments"`
	Date     Datos   `json:"date"`
	Code     string  `json:"code"`
}

//carga util que se envia en una transaccion de peticion de inversores o usuarios del mercado
//secundario
type RequestBondPayload struct {
	Client string `json:"client"`
	ID     string `json:"id"`
	Code   string `json:"code"`
}

type SellBondPayload struct {
	Client string  `json:"client"`
	Amount int     `json:"amount"`
	Price  float64 `json:"price"`
	Code   string  `json:"code"`
}

//carga util que se envia en una transaccion de transferencia
type TransferedPayload struct {
	TransferedBy     string `json:"transferedBy"`
	ChangeUTXOID     string `json:"changeUtxoId"`
	TransferedUTXOID string `json:"transferedUtxoId"`
	Receiver         string `json:"receiver"`
	TransferedAmount int    `json:"transferedamount"`
}

//Carga util que se envia en una transaccion de redimir los UTXOTokens
type RedeemPayload struct {
	Requestor string `json:"requestor"`
	Redeemer  string `json:"redeemer"`
	UTXOID    string `json:"utxoID"`
}

//datos privados que se comparten en una transaccion de redimir los UTXOTokens
type RedeemPrivateData struct {
	UtxoID        string `json:"utxoID"`
	AccountNumber string `json:"accountNumber"`
	Bank          string `json:"bank"`
}

//estructura que agrupa en un mapa todos las identidades de los agricultores que han emitido un pago
type NewFarmerID struct {
	Doctype   string            `json:"docType"`
	Identidad map[string]string `json:"identidad"`
}

//Document Type de los datos privados de las transacciones de WritePayments, RequestBond y Redeem
var (
	RedeemPrivateDataDocType       = "REDEEM"
	UnderwritterPrivateDataDocType = "BOND"
	FarmerPrivateDataDocType       = "FARMER"
)

//No se usa
// var ImplicitCollectionPrefix = "_implicit_org_"

//estructura que usa interfaz. Util cuando a priori no se sabe que se quiere almacenar en esa variable.
type NewState struct {
	DocType string `json:"docType"`
	Value   interface{}
}

//funcion para sumar elementos de un array
func sum(array []float64) float64 {
	result := 0.0
	for _, v := range array {
		result += v
	}
	return result
}

//Funcion que nos devuelve la informacion de los bonos emitidos
func (s *SmartContract) BondInfo(ctx contractapi.TransactionContextInterface) *Bond {
	x := &Bond{
		Doctype:      "Bono",
		ValorEmision: originalvalue,
		Cupon:        cupon,
		Vencimiento:  years * months,
		TiempoPagos:  tiempo_cupon}
	return x
}

//funcion que nos devuelve la fecha de inicio segun la estructura de Datos definida antes
func fecha_inicio() Datos {
	return Datos{
		Day:   1,
		Month: time.Month(7),
		Year:  2021,
	}
}

//Funcion que devuelve la fecha actual en el formato Datos
func queryperiod() Datos {
	fecha := Datos{
		Day:   time.Now().Day(),
		Month: time.Now().Month(),
		Year:  time.Now().Year(),
	}
	return fecha
}

//funcion que manda una peticion con datos privados de que solicita la moneda fiduciaria detras
//del UTXOtoken
func (s *SmartContract) Redeem(ctx contractapi.TransactionContextInterface, utxoID string) (payload RedeemPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	//obtengo el token utxo especificado por utxoID
	utxo, err := s.GetUTXOTokenByID(ctx, "utxotoken", utxoID)
	if err != nil {
		err = ErrExecution
		return
	}
	identity := ctx.GetClientIdentity()
	client, _ := identity.GetID()
	if utxo.Investor != client {
		err = ErrIdentities
		return
	}
	log.Printf("identidades coincides: %v", identity)

	key, err := ctx.GetStub().CreateCompositeKey("utxotoken", []string{utxoID})
	if err != nil {
		err = ErrExecution
		return
	}
	//elimino el estado una vez que solicito el redeem
	err = ctx.GetStub().DelState(key)
	if err != nil {
		err = ErrExecution
		return
	}
	transient, _ := ctx.GetStub().GetTransient()
	err = PutRedeemPrivateData(ctx.GetStub(), transient, utxo.Issuer, utxo.Key)
	if err != nil {
		err = ErrExecution
		return
	}

	//cambiar redeemer
	// org, _ := identity.GetMSPID()
	payload = RedeemPayload{
		Requestor: client,
		Redeemer:  "servicerMSP",
		UTXOID:    utxo.Key,
	}
	return
}

// Funcion para obtener ciertos datos de la private data. No es una funcion dentro de la estructura
//SmartContract
func GetTransientDataValue(stub shim.ChaincodeStubInterface, transient map[string][]byte, transientFieldName string, v interface{}) (err error) {
	transVal, ok := transient[transientFieldName]
	if !ok {
		err = ErrWrongTransFieldName
		return
	}

	if len(transVal) == 0 {
		err = ErrEmptyTransFieldValue
	}

	err = json.Unmarshal(transVal, v)
	return
}

//Funcion que almacena los datos privados asociandolos a una peticion de redeem
func PutRedeemPrivateData(stub shim.ChaincodeStubInterface, transient map[string][]byte, dataReceiver string, utxoID string) (err error) {
	var accountNumber, bank, salt string
	err = GetTransientDataValue(stub, transient, "accountNumber", &accountNumber)
	if err != nil {
		err = ErrExecution
		return
	}
	err = GetTransientDataValue(stub, transient, "bank", &bank)
	if err != nil {
		err = ErrExecution
		return
	}
	err = GetTransientDataValue(stub, transient, "salt", &salt)
	if err != nil {
		err = ErrExecution
		return
	}

	key, err := stub.CreateCompositeKey(RedeemPrivateDataDocType, []string{stub.GetTxID(), salt})
	if err != nil {
		err = ErrExecution
		return
	}
	log.Printf("key: %v", key)
	state := &RedeemPrivateData{
		UtxoID:        utxoID,
		AccountNumber: accountNumber,
		Bank:          bank,
	}
	log.Printf("state: %v", state)

	value, err := json.Marshal(&state)
	if err != nil {
		err = ErrExecution
		return
	}

	dataReceiver = "outro"
	// collection := "bond"
	err = stub.PutPrivateData(dataReceiver, key, value)
	if err != nil {
		err = ErrExecution
		return
	}
	return
}

//esta funcion no esta dentro del smartcontract pero se llama dentro de la funcion IssueBond que subira un estado con un valor que es la propia
//identidad del cliente del SPV. Con este estado que no se podrá borrar nos aseguramos que sólo se emite una vez los bonos
func issue(ctx contractapi.TransactionContextInterface) error {
	// //comprobacion de identidad y atributos
	// //las omitiremos porque ya se hacen estas comprobaciones dentro de la funcion que la implementa
	// hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	// if err != nil {
	// 	return err
	// }
	// if !hasOU {
	// 	return ErrNoSPV
	// }
	identity := ctx.GetClientIdentity()
	spv, err := identity.GetID()
	if err != nil {
		return err
	}
	// org, err := identity.GetMSPID()
	// if err != nil {
	// 	return err
	// }
	// if org != "spvMSP" {
	// 	return ErrNoSPV
	// }
	//esta es la estructura que vamos a guardar. El Doctype se usará para hacer consultas más eficientes (solo disponible con CouchDB)
	spvID := &FarmerID{
		Doctype:   "SPVidentidad",
		Identidad: spv,
	}
	//pasamos a bytes ya que el valor que se guarda siempre son bytes
	spvIDasBytes, err := json.Marshal(spvID)
	if err != nil {
		fmt.Printf("Marshal error: %s", err.Error())
		return err
	}
	//la clave con la que se guarda el valor
	spvKey := ctx.GetStub().GetTxID()
	return ctx.GetStub().PutState(spvKey, spvIDasBytes)
}

func (s *SmartContract) WantToSell(ctx contractapi.TransactionContextInterface, amount int, price float64, utxoID string) (payload SellBondPayload, err error) {
	fecha1 := fecha_inicio()
	fecha2 := queryperiod()

	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1
	if periodo%tiempo_cupon == 0 {
		err = ErrWrongPeriod
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		err = ErrExecution
		return
	}
	if !hasOU {
		err = ErrHasOu
		return
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		err = ErrExecution
		return
	}
	x := 0
	orgs := []string{"spvMSP", "investorMSP"}
	for _, b := range orgs {
		if org != b {
			x = x + 1
		}
	}
	if x == 2 {
		err = ErrWrongOrg
		return
	}
	// if org != "investorMSP" {
	// 	err = ErrWrongOrg
	// 	return
	// }
	key, _ := ctx.GetStub().CreateCompositeKey("utxo", []string{utxoID})

	bondBytes, _ := ctx.GetStub().GetState(key)

	var newutxo *State
	err = json.Unmarshal(bondBytes, &newutxo)
	var utxo UTXOBond
	utxo = newutxo.Valor
	if err != nil {
		log.Printf("error al pillar el estado")
		return
	}
	if utxo.Amount < amount {
		err = ErrWrongNumber
		return
	}
	cliente, _ := identity.GetID()
	if utxo.Investor != cliente {
		err = ErrIdentities
		return
	}
	saleID := ctx.GetStub().GetTxID()
	sale := &ForSale{
		Doctype: "forsale",
		Key:     saleID,
		Owner:   cliente,
		Amount:  amount,
		Price:   price,
		IDBond:  utxoID,
	}
	// saleID := ctx.GetStub().GetTxID()
	saleasBytes, err := json.Marshal(sale)
	if err != nil {
		err = ErrExecution
		return
	}
	err = ctx.GetStub().PutState(saleID, saleasBytes)
	payload = SellBondPayload{
		Client: cliente,
		Amount: amount,
		Price:  price,
		Code:   utxoID,
	}
	return
}

//esta función se usa para emitir UTXOs (moneda) y basarán su valor en los pagos que han realizado los agricultores. La relacion entre moneda
//y token es 1:1
//esta función debe implementarse dentro de otra (ESTO ULTIMO FALTA)
func (s *SmartContract) IssueUTXO(ctx contractapi.TransactionContextInterface, amount int) (payload MintedPayload, err error) {
	// funcion adaptada de https://github.com/braduf/curso-hyperledger-fabric
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	// Check minter authorization - this sample assumes Org1 is the central banker with privilege to mint new tokens
	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		err = ErrExecution
		return
	}
	if !hasOU {
		err = ErrHasOu
		return
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		err = ErrExecution
		return
	}
	//en este caso el que emite las monedas será el originador ya que tiene acceso a los datos privados de los agricultores
	if org != "servicerMSP" {
		err = ErrWrongOrg
		return
	}
	// Get ID of submitting client identity
	minter, err := ctx.GetClientIdentity().GetID()
	if err != nil {
		err = ErrExecution
		return
	}

	// fechainicio := fecha_inicio()
	// fecha := &Datos{
	// 	Day:   time.Now().Day(),
	// 	Month: time.Now().Month(),
	// 	Year:  time.Now().Year(),
	// }

	//declaramos una variable tipo UTXOToken
	//esta se diferencia del otro token en que su clave termina en :0, ademas de los atributos
	var utxo UTXOToken
	utxo = UTXOToken{
		Key:      ctx.GetStub().GetTxID() + ":" + "0",
		Issuer:   minter,
		Investor: minter,
		Amount:   amount,
	}
	//Tambien es distinta el comienzo de la clave con que se guarda el valor
	// the utxo has a composite key of owner:utxoKey, this enables ClientUTXOs() function to query for an owner's utxos.
	utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxotoken", []string{utxo.Key})

	//definimos el doctype, por si queremos consultar todos los estados con doctype=utxoToken
	//tambien cambia la estructura del estado, aunque pudiera ser la misma haciendo que state.Value sea de tipo interfaz y no del
	//tipo del UTXO (bono o moneda) emitido, pero esto complica la consulta
	doctype := "utxoToken"
	state := AnotherState{
		doctype,
		utxo,
	}
	//pasamos a bytes el estado
	value, _ := json.Marshal(&state)

	//subimos el estado como par clave-valor
	err = ctx.GetStub().PutState(utxoCompositeKey, value)
	if err != nil {
		err = ErrExecution
		return
		// return err
	}
	//Esto es el evento que se pasará como after transaction, despues de una transaccion se pasara este evento que contiene datos
	//que el usuario debería guardar
	payload = MintedPayload{
		Minter:   minter,
		UTXOID:   utxo.Key,
		Receiver: minter,
		Code:     "utxoToken",
	}
	return
}

//esta función se usa para tranferir esos tokens basados en los pagos
func (s *SmartContract) TransferUTXO(ctx contractapi.TransactionContextInterface, utxoIDSet []string, amount int, receiver string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	//como entrada podemos pasar uno o varios UTXOs
	// Validate parameters
	if len(utxoIDSet) == 0 {
		return
	}
	if amount <= 0 {
		return
	}
	// TODO: Check decimals of amount
	if receiver == "" {
		return
	}

	//En este caso, los UTXO no tendrán decimales
	// Validate and spend the UTXO set
	totalInputAmount := 0
	spentUTXO := make(map[string]bool)
	var issuer string
	for i, utxoID := range utxoIDSet {
		// Check duplicate ID in utxo set
		if spentUTXO[utxoID] {
			log.Printf("doble gasto")
			return
		}
		// Obtain UTXO from state
		// doctype := "utxoBond"
		var utxo UTXOToken
		// var newutxo interface {}
		var newutxo AnotherState
		var anotherutxo interface{}

		utxoInputCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxotoken", []string{utxoID})

		valueBytes, _ := ctx.GetStub().GetState(utxoInputCompositeKey)

		err = json.Unmarshal(valueBytes, &newutxo)
		if err != nil {
			log.Printf("error al pillar el estado")
			return
		}

		utxo = newutxo.Valor
		log.Printf("utxo: %v", anotherutxo)

		// Set issuer of the first utxo in the set
		if i == 0 {
			issuer = utxo.Issuer
		}
		// Check issuer
		if utxo.Issuer != issuer {
			log.Printf("la identidad no coincide con el issuer")
			return
		}
		// Check owner
		owner, _ := ctx.GetClientIdentity().GetID()
		if utxo.Investor != owner {
			log.Printf("la identidad no coincide con el propietario")
			return
		}
		// Add value to input amount
		totalInputAmount += utxo.Amount

		//eliminamos el antiguo estado del UTXO
		err = ctx.GetStub().DelState(utxoInputCompositeKey)
		if err != nil {
			log.Printf("error al borrar el estado")
			return
		}
		spentUTXO[utxoID] = true
	}

	// Create new outputs
	var transferUTXO, changeUTXO UTXOToken
	if totalInputAmount < amount {
		log.Printf("es menor")
		// err = marketplace.ErrInsufficientTransferFunds
		return
		// return fmt.Errorf("error")
	}
	//Como salida, tendremos 2 UTXO, uno para el nuevo dueño, con indice 0 y otro (si sobra) para el antiguo dueño, con índice 1
	transferUTXO = UTXOToken{
		Key:      ctx.GetStub().GetTxID() + ":" + "0",
		Issuer:   issuer,
		Investor: receiver,
		Amount:   amount,
	}

	utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxotoken", []string{transferUTXO.Key})

	doctype := "utxoToken"
	state := AnotherState{
		doctype,
		transferUTXO,
	}

	value, _ := json.Marshal(&state)
	if err != nil {
		// return err
		return
	}

	err = ctx.GetStub().PutState(utxoCompositeKey, value)
	if err != nil {
		return
		// return err
	}
	owner, _ := ctx.GetClientIdentity().GetID()
	changeAmount := totalInputAmount - amount
	if changeAmount > 0 {
		changeUTXO = UTXOToken{
			Key:      ctx.GetStub().GetTxID() + ":" + "1",
			Issuer:   issuer,
			Investor: owner,
			Amount:   changeAmount,
		}

		utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxotoken", []string{changeUTXO.Key})

		doctype := "utxoToken"
		state := AnotherState{
			doctype,
			changeUTXO,
		}

		value, _ := json.Marshal(&state)
		if err != nil {
			return
			// return err
		}

		err = ctx.GetStub().PutState(utxoCompositeKey, value)
		if err != nil {
			return
		}
	}

	// // Set the event payload
	payload = TransferedPayload{
		TransferedBy:     changeUTXO.Issuer,
		ChangeUTXOID:     changeUTXO.Key,
		TransferedUTXOID: transferUTXO.Key,
		Receiver:         receiver,
		TransferedAmount: int(amount),
	}
	// //ctx.SetEventPayload(payload)
	return
}

//Esta funcion sirve para pasar los pagos de los agricultores, del originador, quien posee los UTXOtoken emitidos por el mismo, al SPV
func (s *SmartContract) TransferPaymentsToSpv(ctx contractapi.TransactionContextInterface, utxoIDSet []string, receiver string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
	}
	if !hasOU {
		return
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		return
	}
	if org != "servicerMSP" {
		return
	}

	//a partir del id de los UTXOtokens (en este caso solo esta previsto que el originador pase un solo UTXO), se obtiene la cantidad de
	//los tokens agrupados y ese total se envía a la SPV
	var id string
	for _, k := range utxoIDSet {
		id = k
	}
	var utxo UTXOToken
	//se obtiene el token detras de esa ID
	utxo, _ = s.GetUTXOTokenByID(ctx, "utxotoken", id)
	log.Printf("token: %v", utxo)
	//se asigna a una variable la cantidad de tokens de esa ID
	amount := utxo.Amount
	log.Printf("cantidad: %v", amount)
	//y se transfiere esa cantidad al receptor
	payload, err = s.TransferUTXO(ctx, utxoIDSet, amount, receiver)
	return
}

//esta funcion agrupa en un UTXOBond todos los UTXOBond que posea un usuario
func (s *SmartContract) PoolUTXOBonds(ctx contractapi.TransactionContextInterface, utxoID []string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
	}
	if !hasOU {
		err = ErrNoSPV
		return
	}
	identity, _ := ctx.GetClientIdentity().GetID()
	if err != nil {
		return
	}
	// id := string(identity)
	log.Printf("utxo: %v", utxoID)
	var cantidad_transferida int
	for _, l := range utxoID {
		log.Printf("clave: %v", l)
		a, _ := s.GetUTXOTokenByID(ctx, "utxo", l)
		cantidad_transferida += a.Amount
	}
	payload, err = s.TransferUTXO(ctx, utxoID, cantidad_transferida, identity)

	return
}

//Idem que la anterior pero con los UTXOToken
func (s *SmartContract) PoolUTXOTokens(ctx contractapi.TransactionContextInterface, utxoID []string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
	}
	if !hasOU {
		err = ErrNoSPV
		return
	}
	identity, _ := ctx.GetClientIdentity().GetID()
	if err != nil {
		return
	}
	// id := string(identity)
	log.Printf("utxo: %v", utxoID)
	var cantidad_transferida int
	for _, l := range utxoID {
		log.Printf("clave: %v", l)
		a, _ := s.GetUTXOTokenByID(ctx, "utxotoken", l)
		log.Printf("aaaaaa: %v", a)
		cantidad_transferida += a.Amount
	}
	payload, err = s.TransferUTXO(ctx, utxoID, cantidad_transferida, identity)

	return
}

//Funcion para consultar de todos los docs que tienen doctype=utxoToken, en cuales de ellos
//aparezco como propietario
func (s *SmartContract) QueryMyTokens(ctx contractapi.TransactionContextInterface) string {
	// hasOU, _ := cid.HasOUValue(ctx.GetStub(), "cliente")
	identity := ctx.GetClientIdentity()
	// org, _ := identity.GetMSPID()
	client, _ := identity.GetID()
	x, _ := s.QueryToken(ctx)
	v := map[string]string{}
	for _, k := range x {
		v[k.Valor.Investor] = k.Valor.Key
		log.Printf("k.Valor.Investor: %v", k.Valor.Key)
	}
	log.Printf("V[CLIENT]: %v", v[client])
	var amount string
	r, exists := v[client]
	if exists {
		amount = r
	}

	return amount
}

//Funcion para distribuit en el periodo igual a tiempo_cupon el cupon de los bonos y el
//principal en caso de estar en fecha de vencimiento.
func (s *SmartContract) DistributeCouponPrincipal(ctx contractapi.TransactionContextInterface, utxoIDSet []string, receiver string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	//consultamos en que periodo estamos
	fecha1 := fecha_inicio()
	fecha2 := queryperiod()

	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1
	if periodo%tiempo_cupon != 0 {
		err = ErrWrongPeriod
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
		// return err
	}
	if !hasOU {
		err = ErrNoSPV
		return
		// return ErrNoSPV
	}
	identity := ctx.GetClientIdentity()
	if err != nil {
		return
		// return err
	}
	org, _ := identity.GetMSPID()
	if org != "spvMSP" {
		err = ErrNoSpv
		return
		// return ErrNoSpv
	}
	amount := s.QueryClientUTXOs(ctx, receiver)
	key, err := ctx.GetStub().CreateCompositeKey("utxo", []string{amount})
	valueBytes, err := ctx.GetStub().GetState(key)
	var value State
	err = json.Unmarshal(valueBytes, &value)
	if err != nil {
		return
	}
	anho := periodo/months + 1

	if (years - anho) == value.Valor.RemainingPayments {
		//ya ha recibido el cupon
		// err=ErrAlready
		return
	}

	var totalTokens int
	for _, t := range utxoIDSet {
		utxo, _ := s.GetUTXOTokenByID(ctx, "utxotoken", t)
		totalTokens = utxo.Amount + totalTokens
	}
	log.Printf("total de tokens: %v", totalTokens)

	cantidad := value.Valor.Amount
	// log.Printf("cantidad: %v", cantidad)

	if (100*cantidad_bonos*int(principal*cupon/100)) > totalTokens && periodo != months*years {
		log.Printf("se necesitan tokens: %v", cantidad_bonos*int(principal*cupon/100))
		err = ErrNoFunds
		return
	}
	if (100*cantidad_bonos*int((principal*(100+cupon)/100))) > totalTokens && periodo == months*years {
		log.Printf("Se necesitan tokens: %v", cantidad_bonos*int((principal*(100+cupon)/100)))
		err = ErrNoFunds
		return
	}

	var total float64
	if periodo == years*months {
		total = principal + (cupon * principal / 100)
		new_total := math.Round(10000*total) / 100
		payload, err = s.TransferUTXO(ctx, utxoIDSet, cantidad*int(new_total), receiver)
	} else {
		total = cupon * principal / 100
		new_total := math.Round(10000*total) / 100
		payload, err = s.TransferUTXO(ctx, utxoIDSet, cantidad*int(new_total), receiver)
	}
	value.Valor.RemainingPayments = value.Valor.RemainingPayments - 1
	value.Valor.AmountPaid = value.Valor.AmountPaid + total
	value2, err := json.Marshal(&value)
	if err != nil {
		return
		// return err
	}
	ctx.GetStub().PutState(key, value2)
	return
}

//Con esta función el originator va a agrupar los pagos que han realizado los agricultores
func (s *SmartContract) PoolPaymentsServicer(ctx contractapi.TransactionContextInterface) (payload MintedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	//añadido 27 abril
	fecha1 := fecha_inicio()
	fecha2 := queryperiod()
	// log.Printf("fecha actual: %v", fecha2)
	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1
	///////////////////////
	//Comprobamos que no se hayan agrupado los pagos, ya que una vez que se agrupen se va a enviar un documento de este estilo
	periodoAsString := strconv.Itoa(periodo)
	oldpoolKey, err := ctx.GetStub().CreateCompositeKey("pool", []string{periodoAsString})
	if err != nil {
		return
		// return fmt.Errorf("failed to read")
	}
	valueBytes, err := ctx.GetStub().GetState(oldpoolKey)
	if err != nil {
		return
		// return fmt.Errorf("failed to read")
	}
	if valueBytes != nil {
		return
		// return fmt.Errorf("These payments have already been pooled")
	}
	//comprobaciones de identidad +atributos
	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
		// return err
	}
	if !hasOU {
		err = ErrNoOriginator
		// return ErrNoOriginator
		return
	}
	identity := ctx.GetClientIdentity()
	spv, err := identity.GetID()
	if err != nil {
		return
		// return err
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return
		// return err
	}
	if org != "servicerMSP" {
		err = ErrNoOriginator
		return
		// return ErrNoOriginator
	}
	log.Printf("Hasta aqui funciona 1")

	//Vamos a suponer que se agrupan los pagos en los periodos en los que los inversores rebiciran su cupon
	//esto es, en multiplos de tiempo_cupon
	if periodo%tiempo_cupon != 0 {
		err = ErrWrongPeriod
		return
	}

	//consulto que para ese periodo se hayan emitido todos los pagos, en caso contrario el originador tendra que "sanitizar"
	//los pagos, i.e., de todos los agricultores buscar quien o quienes no han pagado y ponerle en default
	num, _ := s.QueryAssetNumberByPeriod(ctx, periodo)
	if num < numero_contratos {
		err = ErrNoPeriod
		return
		// return ErrNoPeriod
	}
	log.Printf("ya se han emitido todos los pagos para ese periodo")
	cociente := periodo / tiempo_cupon
	periodo_anterior := (tiempo_cupon * (cociente - 1)) + 1
	var nuevoPPA []*PagosImpagos
	var valor [years * months]float64
	var nuevoValor float64 = 0
	// var total float64
	// for j := periodo_anterior; j < periodo+1; j++ {
	// total = 0
	nuevoPPA, err = s.QueryPaymentsAndDefaultByPeriod(ctx, periodo)
	if periodo == tiempo_cupon {
		for _, k := range nuevoPPA {
			if !k.Default {
				valor = k.Payments
				nuevoValor = nuevoValor + sum(valor[periodo_anterior-1:periodo])
				// total = total + valor
			}
		}
	} else {
		for _, k := range nuevoPPA {
			if !k.Default {
				valor = k.Payments
				nuevoValor = nuevoValor + sum(valor[periodo_anterior:periodo])
				// total = total + valor
			}
		}
	}

	suma := nuevoValor
	// suma := sum(valor[periodo_anterior:periodo])
	// nuevoValor = nuevoValor + total
	// }
	log.Printf("Valor total: %v", nuevoValor)

	pool := &Pool{
		Doctype: "pool",
		Total:   suma,
		Balance: suma,
		Client:  spv,
		State:   "ISSUED",
	}
	//periodoAsString,_:=strconv.Atoi(periodo)

	poolAsBytes, err := json.Marshal(&pool)
	//si no quiero validar el err, defino como elemento, _ :=json.Marshal()
	if err != nil {
		fmt.Printf("Marshal error: %s", err.Error())
		// return err
	}
	//por ultimo, se escribe este documento con clave el periodo en el que se ha emitido y se emite también los UTXO tokens
	poolKey, err := ctx.GetStub().CreateCompositeKey("pool", []string{periodoAsString})
	ctx.GetStub().PutState(poolKey, poolAsBytes)
	new_suma := math.Round(10000*suma) / 100
	payload, err = s.IssueUTXO(ctx, int(new_suma))
	return
}

//esta funcion sirve para consultar de todos los UTXObond, cual es el que posee el cliente y que cantidad posee
func (s *SmartContract) QueryClientUTXOs(ctx contractapi.TransactionContextInterface, client string) string {
	// since utxos have a composite key of owner:utxoKey, we can query for all utxos matching owner:*
	x, _ := s.QueryBond(ctx)
	// var bonds []*UTXOBond
	// var bond UTXOBond
	// var investor string
	v := map[string]string{}
	for _, k := range x {
		v[k.Valor.Investor] = k.Valor.Key
		log.Printf("k.Valor.Investor: %v", k.Valor.Key)
		// bonds = append(bonds, &bond)
	}
	log.Printf("V[CLIENT]: %v", v[client])
	var amount string
	r, exists := v[client]
	if exists {
		amount = r
	}
	return amount
}

//Con esta función un futuro bonista, tanto perteneciente a la org underwritter como a la org secondary market, solicitaría una
//cantidad de bonos.
func (s *SmartContract) RequestBond(ctx contractapi.TransactionContextInterface, cantidad int, id string) (payload RequestBondPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	//la cantidad es un numero entero positivo menor que el total de bonos
	if cantidad > cantidad_bonos && cantidad < 0 {
		err = ErrWrongNumber
		return
		// return ErrWrongNumber
	}
	//Comprobaciones de identidad+atributos
	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
		// return err
	}
	if !hasOU {
		err = ErrNoUnderwritter
		return
		// return ErrNoUnderwritter
	}
	identity := ctx.GetClientIdentity()
	underwritter, err := identity.GetID()
	if err != nil {
		return
		// return err
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return
		// return err
	}
	// x := 0
	// orgs := []string{"underwritterMSP", "aggregatorMSP"}
	// for _, b := range orgs {
	// 	if org != b {
	// 		x = x + 1
	// 	}
	// }
	if org != "investorMSP" {
		err = ErrNoUnderwritter
		return
		// return ErrNoUnderwritter
	}
	requestKey := ctx.GetStub().GetTxID()
	finalKey, _ := ctx.GetStub().CreateCompositeKey("request", []string{underwritter, requestKey})
	request := &Request{
		Doctype:    "request",
		Requester:  underwritter,
		Amount:     cantidad,
		KeyRequest: id,
		// RequestedAt: time.UTC,
	}
	requestAsBytes, err := json.Marshal(&request)
	if err != nil {
		return
		// fmt.Printf("Marshal error: %s", err.Error())
		// return err
	}
	err = ctx.GetStub().PutState(finalKey, requestAsBytes)
	err = ctx.GetStub().DelState(id)
	transientMap, err := ctx.GetStub().GetTransient()
	if err != nil {
		return
		// return shim.Error("Expecting integer value for asset holding")
		// return fmt.Errorf("Error al subir: %v", err)
	}
	err = PutUnderwritterPrivateData(ctx, transientMap)
	if err != nil {
		return
	}
	payload = RequestBondPayload{
		Client: underwritter,
		ID:     id,
		// Payments: payments,
		// Date:     ppa.Fecha,
		Code: "request",
	}

	// jsonAsBytes, _ := json.Marshal(`"{sending payments to receipient: ` + farmer + ` }"`)
	// err = ctx.GetStub().SetEvent("Payments distributed: ", jsonAsBytes)
	return
}

//Datos privados asociados a una solicitud de request
//https://github.com/braduf/curso-hyperledger-fabric
func PutUnderwritterPrivateData(ctx contractapi.TransactionContextInterface, transient map[string][]byte) (err error) {
	var underwritterPrivateData interface{}
	// err = GetTransientDataValue(ctx.GetStub(), transient, "farmerPrivateData", &farmerPrivateData)
	if err != nil {
		return
	}

	transVal, ok := transient["underwritterPrivateData"]
	if !ok {
		// err = ErrWrongTransFieldName
		return nil
	}

	if len(transVal) == 0 {
		// err = ErrEmptyTransFieldValue
		return nil
	}

	err = json.Unmarshal(transVal, &underwritterPrivateData)

	key, err := ctx.GetStub().CreateCompositeKey(FarmerPrivateDataDocType, []string{ctx.GetStub().GetTxID()})
	if err != nil {
		return
	}
	state := NewState{
		UnderwritterPrivateDataDocType,
		underwritterPrivateData,
	}
	value, err := json.Marshal(&state)
	if err != nil {
		return
	}
	collection := "bond"

	err = ctx.GetStub().PutPrivateData(collection, key, value)
	return
}

//Logica que se ejecuta antes de la transaccion. Creo que no esta funcionando. Pero aqui se pondria una consulta de
//cual es la funcion ejecutada en caso de que no esten emitidos los bonos. Así se impide que se haga cualquier cosa
//antes de la emision
func BeforeTransaction(ctx contractapi.TransactionContextInterface) (err error) {
	stub := ctx.GetStub()
	hasChannelOU, err := cid.HasOUValue(stub, stub.GetChannelID())
	if err != nil {
		return
	}
	if !hasChannelOU {
		return
	}
	msp, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return
	}
	log.Printf("msp: %v", msp)
	return
}

//Esta función va dentro del after transaction que devuelve el event de la funcion ejecutada. Cada funcion importante tendra un event.
func SetContractEvent(stub shim.ChaincodeStubInterface, payload interface{}) (err error) {
	funcName, _ := stub.GetFunctionAndParameters()

	event, ok := EventNames[funcName]
	if !ok {
		// No event should be set for this function
		return
	}

	// err = stub.SetEvent(stub, event, payload)
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return
	}
	err = stub.SetEvent(event, payloadBytes)
	return
}

//Aqui está la lógica que se ejecuta post transaccion
func AfterTransaction(ctx contractapi.TransactionContextInterface, txReturnValue interface{}) (err error) {
	// After most transactions an event should be fired
	SetContractEvent(ctx.GetStub(), txReturnValue)
	return
}

//Esta funcion almacena los datos privados asociados al pago que realiza el agricultor (Modificar para que lo que se sube al Ledger
//sea lo mismo que lo que va en la private data)
//https://github.com/braduf/curso-hyperledger-fabric
func PutFarmerPrivateData(ctx contractapi.TransactionContextInterface, transient map[string][]byte) (err error) {
	var farmerPrivateData interface{}
	// err = GetTransientDataValue(ctx.GetStub(), transient, "farmerPrivateData", &farmerPrivateData)
	if err != nil {
		return
	}

	transVal, ok := transient["farmerPrivateData"]
	if !ok {
		// err = ErrWrongTransFieldName
		return nil
	}

	if len(transVal) == 0 {
		// err = ErrEmptyTransFieldValue
		return nil
	}

	err = json.Unmarshal(transVal, &farmerPrivateData)

	key, err := ctx.GetStub().CreateCompositeKey(FarmerPrivateDataDocType, []string{ctx.GetStub().GetTxID()})
	if err != nil {
		return
	}
	state := NewState{
		FarmerPrivateDataDocType,
		farmerPrivateData,
	}
	value, err := json.Marshal(&state)
	if err != nil {
		return
	}
	collection := "ppa"

	err = ctx.GetStub().PutPrivateData(collection, key, value)
	return
}

//ejemplo fabric-sample
//esta función crea "amount" UTXOs que tiene que ser entero (para hacer una equivalencia con los pagos: pagos*100)
//la creación se hace en el momento en que se registra el pago por parte del client del farmer si el default es false. El client no controla que
//cantidad emite, es directamente el pago*100 y no va a poder eliminar el UTXO (falta por implementar DELETEUTXO)
//Se asegura que la ID del utxo es unica, pues se crea a partir del usuario y de la ID de la transaccion
//seria interesante cambiar a que la funcion no se pudiese ejecutar, que fuese una interfaz

//Esta funcion es como IssueUTXO pero en lugar de emitir un token moneda emite un token bono
func (s *SmartContract) IssueBond(ctx contractapi.TransactionContextInterface) (payload MintedPayload, err error) {
	//Comprobaciones de identidad+atributo
	// Check minter authorization - this sample assumes Org1 is the central banker with privilege to mint new tokens
	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		// return err
		return
	}
	if !hasOU {
		// return ErrNoSPV
		return
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		return
		// return err
	}
	if org != "spvMSP" {
		return
		// return ErrNoSPV
	}
	// Get ID of submitting client identity
	minter, err := ctx.GetClientIdentity().GetID()
	if err != nil {
		return
		// return fmt.Errorf("failed to get client id: %v", err)
	}

	fechainicio := fecha_inicio()
	fecha := &Datos{
		Day:   time.Now().Day(),
		Month: time.Now().Month(),
		Year:  time.Now().Year(),
	}

	fecha_vencimiento := Datos{
		Day:   7,
		Month: time.Month(6),
		Year:  2031,
	}
	// log.Printf("fecha actual: %v", fecha)
	// log.Printf("fecha inicio: %v", fechainicio)

	// log.Printf("anho: %v", fecha.Year)
	// log.Printf("anho inicio: %v", fechainicio.Year)
	// log.Printf("mes: %v", fecha.Month)
	// log.Printf("mes inicio: %v", fechainicio.Month)

	//Comprobamos que la fecha actual de emision coincida con la fecha de inicio establecia como constante
	if fecha.Month != fechainicio.Month || fecha.Year != fechainicio.Year {
		return
		// return fmt.Errorf("Not possible to issue bond")
	}
	//se comprueba que no se hayan emitido los bonos
	identidades, err := s.QueryIdentitiesSPV(ctx)
	// log.Printf("identidades: %v", identidades)
	//la cantidad de bonos es una constante, por lo que la SPV no podra modificar el numero a su antojo.
	amount := cantidad_bonos
	var utxo UTXOBond
	//si nadie ha emitido los bonos, se declara la estructura
	if identidades == nil {
		utxo = UTXOBond{
			Key:        ctx.GetStub().GetTxID() + ".0",
			Issuer:     minter,
			Investor:   minter,
			Amount:     amount,
			CouponRate: cupon,
			// Value:             "0",
			MaturityDate:      fecha_vencimiento,
			AmountPaid:        0.00,
			OriginalValue:     originalvalue,
			MonthlyPayout:     cupon * principal,
			RemainingPayments: years,
		}
		// the utxo has a composite key of owner:utxoKey, this enables ClientUTXOs() function to query for an owner's utxos.
		utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxo", []string{utxo.Key})

		doctype := "utxoBond"
		state := State{
			doctype,
			utxo,
		}

		value, _ := json.Marshal(&state)
		//y se envian el documento que indica que un miembro del SPV ha emitido bonos y el token con los 5000 bonos
		err = ctx.GetStub().PutState(utxoCompositeKey, value)
		if err != nil {
			return
			// return err
		}
		err = issue(ctx)
		if err != nil {
			// fmt.Printf("error: %s", err.Error())
			// return err
			return
		}
	} else {
		return
		// return ErrSPVBond
	}
	//y se crea el evento que pasara el aftertransaction
	payload = MintedPayload{
		Minter:   minter,
		UTXOID:   utxo.Key,
		Receiver: minter,
		Code:     "utxoBond",
	}
	return
}

// Funcion para transferir los bonos
//https://github.com/braduf/curso-hyperledger-fabric
func (s *SmartContract) Transfer(ctx contractapi.TransactionContextInterface, utxoIDSet []string, amount int, receiver string) (payload TransferedPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	// func (s *SmartContract) Transfer(ctx contractapi.TransactionContextInterface, utxoIDSet []string, amount int, receiver string) (payload TransferedPayload, err error) {
	// Validate parameters
	if len(utxoIDSet) == 0 {
		return
		// err = marketplace.ErrTransferEmptyUTXOSet
		// return
	}
	if amount <= 0 {
		return
	}
	// TODO: Check decimals of amount
	if receiver == "" {
		return
	}
	var remaining int
	var monthly float64
	var amountpaid float64
	var originalvalue float64
	// Validate and spend the UTXO set
	totalInputAmount := 0
	spentUTXO := make(map[string]bool)
	var issuer string
	for i, utxoID := range utxoIDSet {
		// Check duplicate ID in utxo set
		if spentUTXO[utxoID] {
			log.Printf("doble gasto")
			return
		}
		// Obtain UTXO from state
		// doctype := "utxoBond"
		var utxo UTXOBond
		// var newutxo interface {}
		var newutxo State
		var anotherutxo interface{}

		utxoInputCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxo", []string{utxoID})

		// log.Printf("key: %v", utxoID)
		// if err != nil {
		// 	log.Printf("error composite key %v", err)
		// 	// return nil, fmt.Errorf("failed to create composite key: %v", err)
		// 	return
		// }
		// validate that client has a utxo matching the input key
		// valueBytes, err := ctx.GetStub().GetState(utxoInputCompositeKey)
		valueBytes, _ := ctx.GetStub().GetState(utxoInputCompositeKey)

		// if err != nil {
		// 	log.Printf("esta aqui el error")
		// 	return
		// 	// return err
		// }
		err = json.Unmarshal(valueBytes, &newutxo)
		if err != nil {
			log.Printf("error al pillar el estado")
			// return nil, fmt.Errorf("failed to read utxoInputCompositeKey %s from world state: %v", utxoInputCompositeKey, err)
			return
		}
		utxo = newutxo.Valor
		log.Printf("utxo: %v", anotherutxo)

		// Set issuer of the first utxo in the set
		if i == 0 {
			issuer = utxo.Issuer
		}
		// Check issuer
		if utxo.Issuer != issuer {
			log.Printf("la identidad no coincide con el issuer")
			// err = marketplace.ErrOnlySameIssuerTransfer
			// return fmt.Errorf("error")
			return
		}
		// Check owner
		owner, _ := ctx.GetClientIdentity().GetID()
		if utxo.Investor != owner {
			log.Printf("la identidad no coincide con el propietario")
			// err = marketplace.ErrOnlyOwnerTransfer
			return
			// return fmt.Errorf("error")
		}
		// Add value to input amount
		remaining = utxo.RemainingPayments
		monthly = utxo.MonthlyPayout
		amountpaid = utxo.AmountPaid
		originalvalue = utxo.OriginalValue

		totalInputAmount += utxo.Amount

		err = ctx.GetStub().DelState(utxoInputCompositeKey)
		if err != nil {
			log.Printf("error al borrar el estado")
			return
			// return fmt.Errorf("error")
		}
		spentUTXO[utxoID] = true
	}

	// Create new outputs
	var transferUTXO, changeUTXO UTXOBond
	if totalInputAmount < amount {
		log.Printf("es menor")
		// err = marketplace.ErrInsufficientTransferFunds
		return
		// return fmt.Errorf("error")
	}
	fecha_vencimiento := Datos{
		Day:   7,
		Month: time.Month(6),
		Year:  2031,
	}

	transferUTXO = UTXOBond{
		Key:        ctx.GetStub().GetTxID() + ".0",
		Issuer:     issuer,
		Investor:   receiver,
		Amount:     amount,
		CouponRate: cupon,
		// Value:             "0",
		MaturityDate:      fecha_vencimiento,
		AmountPaid:        0.00,
		OriginalValue:     originalvalue,
		MonthlyPayout:     monthly,
		RemainingPayments: remaining,
	}

	utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxo", []string{transferUTXO.Key})

	doctype := "utxoBond"
	state := State{
		doctype,
		transferUTXO,
	}

	value, err := json.Marshal(&state)
	if err != nil {
		return
		// return err
	}

	err = ctx.GetStub().PutState(utxoCompositeKey, value)
	if err != nil {
		return
		// return err
	}

	owner, _ := ctx.GetClientIdentity().GetID()
	changeAmount := totalInputAmount - amount
	if changeAmount > 0 {
		changeUTXO = UTXOBond{
			Key:        ctx.GetStub().GetTxID() + ".1",
			Issuer:     issuer,
			Investor:   owner,
			Amount:     changeAmount,
			CouponRate: cupon,
			// Value:             "0",
			MaturityDate:      fecha_vencimiento,
			AmountPaid:        amountpaid,
			OriginalValue:     originalvalue,
			MonthlyPayout:     monthly,
			RemainingPayments: remaining,
		}

		utxoCompositeKey, _ := ctx.GetStub().CreateCompositeKey("utxo", []string{changeUTXO.Key})

		doctype := "utxoBond"
		state := State{
			doctype,
			changeUTXO,
		}

		value, _ := json.Marshal(&state)
		if err != nil {
			return
		}

		err = ctx.GetStub().PutState(utxoCompositeKey, value)
		if err != nil {
			return
		}
	}

	// // Set the event payload
	payload = TransferedPayload{
		TransferedBy:     changeUTXO.Issuer,
		ChangeUTXOID:     changeUTXO.Key,
		TransferedUTXOID: transferUTXO.Key,
		Receiver:         receiver,
		TransferedAmount: amount,
	}
	return
}

//devuelve la historia de cada utxo
// GetHistoryOfUTXO can be used to search through the history of a UTXO
// https://github.com/braduf/curso-hyperledger-fabric
func (s *SmartContract) GetHistoryOfUTXO(ctx contractapi.TransactionContextInterface, id string) (historyInJSONString string, err error) {
	historyInJSONString, err = GetHistoryForCurrencyUTXOID(ctx.GetStub(), id)
	return
}

//A partir de la ID de un bono obtenemos su informacion
func (s *SmartContract) GetUTXOByID(ctx contractapi.TransactionContextInterface, code string, id string) (utxo UTXOBond, err error) {
	key, err := ctx.GetStub().CreateCompositeKey(code, []string{id})
	if err != nil {
		return
	}
	var utxoState State
	utxoBytes, err := ctx.GetStub().GetState(key)
	json.Unmarshal(utxoBytes, &utxoState)
	if err != nil {
		return
	}
	utxo = utxoState.Valor
	return
}

//A partir de la ID de un UTXO token, obtenemos la informacion que está detras. Por eso es importante guardar la clave.
func (s *SmartContract) GetUTXOTokenByID(ctx contractapi.TransactionContextInterface, code string, id string) (utxo UTXOToken, err error) {
	key, err := ctx.GetStub().CreateCompositeKey(code, []string{id})
	log.Printf("clave: %v", key)
	if err != nil {
		return
	}

	var utxoState AnotherState
	// var utxoState NewState
	utxoBytes, err := ctx.GetStub().GetState(key)
	err = json.Unmarshal(utxoBytes, &utxoState)
	if err != nil {
		return
	}
	log.Printf("estado: %v", utxoState)
	utxo = utxoState.Valor
	log.Printf("utxo: %v", utxo)
	return
}

//https://github.com/braduf/curso-hyperledger-fabric
func GetHistoryForCurrencyUTXOID(stub shim.ChaincodeStubInterface, id string) (historyJSONString string, err error) {
	key, err := stub.CreateCompositeKey("utxo", []string{id})
	if err != nil {
		return
	}
	historyBuffer, err := GetHistoryForKey(stub, key)
	if err != nil {
		return
	}
	historyJSONString = string(historyBuffer.Bytes())

	return
}

// GetHistoryForKey is a function to get the historic values of a specific key of the World State
// https://github.com/braduf/curso-hyperledger-fabric
func GetHistoryForKey(stub shim.ChaincodeStubInterface, key string) (*bytes.Buffer, error) {
	historyIterator, err := stub.GetHistoryForKey(key)
	if err != nil {
		return nil, err
	}
	defer historyIterator.Close()

	// buffer is a JSON array containing historic values for the key
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for historyIterator.HasNext() {
		var response *queryresult.KeyModification
		response, err = historyIterator.Next()
		if err != nil {
			return nil, err
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"TxId\":")
		buffer.WriteString("\"")
		buffer.WriteString(response.TxId)
		buffer.WriteString("\"")

		// If it was a delete operation on a given key, then there is no value on the key anymore.
		// So only write the response.Value as-is when it was not a delete operation.
		if !response.IsDelete {
			buffer.WriteString(", \"Value\":")
			buffer.WriteString(string(response.Value))
		}

		buffer.WriteString(", \"Timestamp\":")
		buffer.WriteString("\"")
		buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		buffer.WriteString("\"")

		buffer.WriteString(", \"IsDelete\":")
		buffer.WriteString("\"")
		buffer.WriteString(strconv.FormatBool(response.IsDelete))
		buffer.WriteString("\"")

		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	return &buffer, nil
}

//esta función de usa para obtener la ID del usuario. Esta informacion no es privada
func (s *SmartContract) ClientID(ctx contractapi.TransactionContextInterface) (string, error) {
	// Get ID of submitting client identity
	clientID, err := ctx.GetClientIdentity().GetID()
	if err != nil {
		return "", fmt.Errorf("failed to get client id: %v", err)
	}
	return clientID, nil
}

//función que permite a los clients del farmer emitir una transaccion con su identidad (publica) al ledger
//puede ser interesante que esto se transfiera como PrivateData entre spv, originator y farmer, o con un canal aparte
func (s *SmartContract) RegisteringFarmers(ctx contractapi.TransactionContextInterface) (payload RegisterIdentityPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
		// return err
	}
	if !hasOU {
		err = ErrNoFarmer
		return
		// return ErrNoFarmer
	}

	identity := ctx.GetClientIdentity()
	farmer, err := identity.GetID()
	if err != nil {
		return
		// return err
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return
		// return err
	}
	if org != "farmerMSP" {
		err = ErrNoFarmer
		return
		// return ErrNoFarmer
	}
	log.Printf("Pasa todos los filtros de identidad")

	farmerID := &FarmerID{
		Doctype:   "identidad",
		Identidad: farmer,
	}
	farmerIDasBytes, err := json.Marshal(farmerID)
	if err != nil {
		// fmt.Printf("Marshal error: %s", err.Error())
		return
		// return err
	}
	farmerKey := ctx.GetStub().GetTxID()
	log.Printf("ppakey: %v", farmerKey)

	err = ctx.GetStub().PutState(farmerKey, farmerIDasBytes)
	if err != nil {
		// fmt.Printf("Marshal error: %s", err.Error())
		return
		// return err
	}
	payload = RegisterIdentityPayload{
		UserID: farmer,
		Code:   "identity",
	}
	return
}

//Con esta funcion agrupamos en un mapa todas las identidades que hayan emitido pago en un periodo. Esto hará mas facil su manejo
func (s *SmartContract) PoolIndentities(ctx contractapi.TransactionContextInterface) error {

	fecha1 := fecha_inicio()
	fecha2 := queryperiod()
	log.Printf("fecha actual: %v", fecha2)
	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return err
	}
	if !hasOU {
		return ErrNoOriginator
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		return err
	}
	if org != "servicerMSP" {
		return ErrNoOriginator
	}
	var x []*FarmerID
	x, err = s.QueryFarmerIDByPeriod(ctx, periodo)
	log.Printf("identidades: %v", x)
	// x, _ := s.QueryIdentities(ctx)
	v := map[string]string{}
	for _, k := range x {
		v[k.Identidad] = k.Identidad
	}
	log.Printf("mapa: %v", v)
	farmerID := &NewFarmerID{
		Doctype:   "mapa",
		Identidad: v,
	}
	farmerIDasBytes, _ := json.Marshal(farmerID)

	// stateKey := ctx.GetStub().GetTxID()

	return ctx.GetStub().PutState("farmersmap", farmerIDasBytes)
}

//Funciona correctamente

//A partir de ese mapa de identidades el originator comprobará que identidades no han emitido el pago (ya que antes han en
// enviado un documento con su id a modo de registro)y las mandará a default.
func (s *SmartContract) SanitizeFarmerPayments(ctx contractapi.TransactionContextInterface) error {
	fecha1 := fecha_inicio()
	fecha2 := queryperiod()
	log.Printf("fecha actual: %v", fecha2)
	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1

	log.Printf("numero de periodo: %v", periodo)
	///////////////////////
	//	periodoAsString := strconv.Itoa(periodo)

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return err
	}
	if !hasOU {
		return ErrNoOriginator
	}
	identity := ctx.GetClientIdentity()
	org, err := identity.GetMSPID()
	if err != nil {
		return err
	}
	if org != "servicerMSP" {
		return ErrNoOriginator
	}

	ppaAsBytes, err := ctx.GetStub().GetState("farmersmap")
	if err != nil {
		return nil
	}
	if ppaAsBytes == nil {
		return nil
	}
	var mapa NewFarmerID
	err = json.Unmarshal(ppaAsBytes, &mapa)
	if err != nil {
		return nil
	}

	var x []*FarmerID
	// x, err = s.QueryFarmerIDByPeriod(ctx, periodo)

	x, err = s.QueryIdentities(ctx)
	if err != nil {
		return nil
	}

	for _, k := range x {
		v, exists := mapa.Identidad[k.Identidad]
		// log.Printf("otra identidad: %v", v)
		log.Printf("existe: %v", exists)
		if !exists {
			v = k.Identidad
			log.Printf("here it is: %v", v)
			ppaKey, err := ctx.GetStub().CreateCompositeKey("payment", []string{k.Identidad})
			log.Printf("crea mal la clave: %v", ppaKey)
			var ppaOld *PPA
			if periodo != 1 {
				log.Printf("periodo distinto de 1")
				ppaOld, err = s.QueryAssetByID(ctx, ppaKey)
				if err != nil {
					// return shim.Error("Expecting integer value for asset holding")
					return err
				}
				energy := 0.000
				payments := energy * precio_kwh

				payments = math.Round(payments*100) / 100
				log.Printf("empiezan aqui los fallos")
				ppaOld.Energy[periodo-1] = energy
				ppaOld.Payments[periodo-1] = payments
				ppa := &PPA{
					DocType:  "ppa",
					Client:   v,
					Energy:   ppaOld.Energy,
					Payments: ppaOld.Payments,
					Default:  true,
					Period:   periodo,
					Fecha: Datos{
						Day:   time.Now().Day(),
						Month: time.Now().Month(),
						Year:  time.Now().Year(),
					},
				}
				log.Printf("llega hasta 2")
				ppaAsBytes, err := json.Marshal(&ppa)
				log.Printf("llega hasta final")
				// ppaKey = ctx.GetStub().GetTxID()
				err = ctx.GetStub().PutState(ppaKey, ppaAsBytes)
				if err != nil {
					return err
				}
				log.Printf("llega hasta final")

			} else {
				// var ppaOld PPA
				energy := 0.000
				payments := energy * precio_kwh

				payments = math.Round(payments*100) / 100
				log.Printf("empiezan aqui los fallos")
				var ppaOldEnergy [years * months]float64
				var ppaOldPayments [years * months]float64
				ppaOldEnergy[periodo-1] = energy
				ppaOldPayments[periodo-1] = payments

				// ppaOld.Energy[0] = energy
				// ppaOld.Payments[0] = payments
				// log.Printf(ppaOld.Energy)
				ppa := &PPA{
					DocType:  "ppa",
					Client:   v,
					Energy:   ppaOldEnergy,
					Payments: ppaOldPayments,
					Default:  true,
					Period:   periodo,
					Fecha: Datos{
						Day:   time.Now().Day(),
						Month: time.Now().Month(),
						Year:  time.Now().Year(),
					},
				}
				log.Printf("llega hasta 2")
				ppaAsBytes, err := json.Marshal(&ppa)
				log.Printf("llega hasta final")
				// ppaKey = ctx.GetStub().GetTxID()
				err = ctx.GetStub().PutState(ppaKey, ppaAsBytes)
				if err != nil {
					return err
				}
				log.Printf("llega hasta final")

			}
			log.Printf("llega hasta 1")
			// ppaOld.DocType = "ppa"
			// ppaOld.Client = v
			// ppaOld.Default = true
			// ppaOld.Period = periodo
			// ppaOld.Fecha = Datos{
			// 	Day:   time.Now().Day(),
			// 	Month: time.Now().Month(),
			// 	Year:  time.Now().Year(),
			// }

			// ppa := &PPA{
			// 	DocType:  "ppa",
			// 	Client:   v,
			// 	Energy:   ppaOld.Energy,
			// 	Payments: ppaOld.Payments,
			// 	Default:  true,
			// 	Period:   periodo,
			// 	Fecha: Datos{
			// 		Day:   time.Now().Day(),
			// 		Month: time.Now().Month(),
			// 		Year:  time.Now().Year(),
			// 	},
			// }
			// log.Printf("llega hasta 2")
			// ppaAsBytes, err := json.Marshal(&ppa)
			//si no quiero validar el err, defino como elemento, _ :=json.Marshal()
			// if err != nil {
			// 	return err
			// }
			// log.Printf("llega hasta final")
			// // ppaKey = ctx.GetStub().GetTxID()
			// err = ctx.GetStub().PutState(ppaKey, ppaAsBytes)
			// if err != nil {
			// 	return err
			// }
			// log.Printf("llega hasta final")
		}
	}

	return nil
}

//funciona correctamente. Comprobar que pasa si el número de los que no han emitido pago es muy alto.

//Esta función sirve para consultar todos los pagos que ha realizado una determinada ID. Se usan indexes, por lo que solo busca
//los que tengan esa ID
func (s *SmartContract) GetHistoryFarmer(ctx contractapi.TransactionContextInterface, farmer string) ([]*PPA, error) {
	identity := ctx.GetClientIdentity()
	farmer, err := identity.GetID()
	if err != nil {
		return nil, err
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return nil, err
	}
	if org != "spvMSP" {
		return nil, ErrNoSpv
	}
	var nuevoPPA []*PPA
	nuevoPPA, err = s.QueryIdentityHistory(ctx, farmer)
	return nuevoPPA, err
}

//sseria interesante en esta pasar private data quefuncione como comprobante de que efectivamente se ha realizado el pago
//Esta función servirá para que los agricultores envien los pagos
func (s *SmartContract) WritePayments(ctx contractapi.TransactionContextInterface, energy float64) (payload WritePaymentsPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}

	fecha1 := fecha_inicio()
	fecha2 := queryperiod()
	// log.Printf("fecha actual: %v", fecha2)
	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1

	// log.Printf("numero de periodo: %v", periodo)

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
		// return err
		// return shim.Error("Expecting integer value for asset holding")
	}
	if !hasOU {
		err = ErrNoFarmer
		return
		// return shim.Error("Expecting integer value for asset holding")
		// return ErrNoFarmer
	}
	identity := ctx.GetClientIdentity()
	farmer, err := identity.GetID()
	if err != nil {
		return
		// return shim.Error("Expecting integer value for asset holding")
		// return err
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return
	}
	if org != "farmerMSP" {
		err = ErrNoFarmer
		return
	}

	//QUITAR PARA USAR CALIPER
	num, _ := s.QueryAssetNumberByPeriod(ctx, periodo)
	if num >= numero_contratos {
		err = ErrNoPeriod
		return
	}

	//comprobacion quitada al añadir los vectores de energía y pagos
	// if num == 0 && periodo > 1 {
	// 	num, _ := s.QueryAssetNumberByPeriod(ctx, periodo-1)
	// 	if num != numero_contratos {
	// 		err = ErrNoPeriod
	// 		return
	// 	}
	// }

	//QUITAR PARA USAR CALIPER
	//Compruebo el historial de pagos y si la identidad emisora coincide con el agricultor y en el
	//periodo actual, significa que ya ha enviado el pago.
	ppa_client, err := s.QueryIdentityHistory(ctx, farmer)
	for _, rango_client := range ppa_client {
		if rango_client.Period == periodo && rango_client.Client == farmer {
			err = ErrFarmerPeriod
			return
		}
	}
	ppaKey, err := ctx.GetStub().CreateCompositeKey("payment", []string{farmer})
	// ppaKey := ctx.GetStub().GetTxID()
	if err != nil {
		return
	}
	var ppa *PPA
	var payments float64
	if periodo == 1 {
		payments = energy * precio_kwh
		payments = math.Round(payments*100) / 100
		var ppaOldEnergy [years * months]float64
		var ppaOldPayments [years * months]float64
		ppaOldEnergy[periodo-1] = energy
		ppaOldPayments[periodo-1] = payments
		de_fault := false

		ppa = &PPA{
			DocType:  "ppa",
			Client:   farmer,
			Energy:   ppaOldEnergy,
			Payments: ppaOldPayments,
			Default:  de_fault,
			Period:   periodo,
			Fecha: Datos{
				Day:   time.Now().Day(),
				Month: time.Now().Month(),
				Year:  time.Now().Year(),
			},
		}
	} else {
		var ppaOld *PPA
		ppaKey, err = ctx.GetStub().CreateCompositeKey("payment", []string{farmer})
		if err != nil {
			return
		}
		ppaOld, err = s.QueryAssetByID(ctx, ppaKey)
		if err != nil {
			return
		}

		payments = energy * precio_kwh
		payments = math.Round(payments*100) / 100
		ppaOld.Energy[periodo-1] = energy
		ppaOld.Payments[periodo-1] = payments
		de_fault := false

		ppa = &PPA{
			DocType:  "ppa",
			Client:   farmer,
			Energy:   ppaOld.Energy,
			Payments: ppaOld.Payments,
			Default:  de_fault,
			Period:   periodo,
			Fecha: Datos{
				Day:   time.Now().Day(),
				Month: time.Now().Month(),
				Year:  time.Now().Year(),
			},
		}

	}
	ppaAsBytes, err := json.Marshal(&ppa)
	//si no quiero validar el err, defino como elemento, _ :=json.Marshal()
	if err != nil {
		return
		// fmt.Printf("Marshal error: %s", err.Error())
	}

	/////////////////////////////////////////
	/////////////////////////////////////////
	//OJO ESTO ESTA COMENTADO EN CASO NORMAL
	//descomentar para probar la performance de la red
	//////////////////////////////////////////
	////////////////////////////////////////
	// ppaKey = ctx.GetStub().GetTxID()

	err = ctx.GetStub().PutState(ppaKey, ppaAsBytes)
	if err != nil {
		return
	}
	transientMap, err := ctx.GetStub().GetTransient()
	if err != nil {
		return
	}
	err = PutFarmerPrivateData(ctx, transientMap)
	if err != nil {
		return
	}
	payload = WritePaymentsPayload{
		Client:   farmer,
		Payments: payments,
		Date:     ppa.Fecha,
		Code:     "payments",
	}
	return
}

//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//####################################################PRUEBA############################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################

//Con esta funcion se envian los pagos de 12 periodos, se ha usado para hacer pruebas.
func (s *SmartContract) SimulatePayments(ctx contractapi.TransactionContextInterface, energy1 float64, energy2 float64, energy3 float64, energy4 float64, energy5 float64, energy6 float64, energy7 float64, energy8 float64, energy9 float64, energy10 float64, energy11 float64, energy12 float64) (payload WritePaymentsPayload, err error) {
	identidades, err := s.QueryIdentitiesSPV(ctx)
	if identidades == nil {
		err = ErrFirstBond
		return
	}
	energy := [tiempo_cupon]float64{energy1, energy2, energy3, energy4, energy5, energy6, energy7, energy8, energy9, energy10, energy11, energy12}
	fecha1 := fecha_inicio()
	fecha2 := queryperiod()
	// log.Printf("fecha actual: %v", fecha2)
	var y1 int = int(fecha2.Month)
	var y0 int = int(fecha1.Month)
	periodo := (12*fecha2.Year + y1) - (12*fecha1.Year + y0) + 1

	hasOU, err := cid.HasOUValue(ctx.GetStub(), "cliente")
	if err != nil {
		return
	}
	if !hasOU {
		err = ErrNoFarmer
		return
	}
	identity := ctx.GetClientIdentity()
	farmer, err := identity.GetID()
	if err != nil {
		return
	}
	org, err := identity.GetMSPID()
	if err != nil {
		return
	}
	if org != "farmerMSP" {
		err = ErrNoFarmer
		return
	}
	num, _ := s.QueryAssetNumberByPeriod(ctx, periodo)
	if num >= numero_contratos {
		err = ErrNoPeriod
		return
	}
	// if num == 0 && periodo > 1 {
	// 	num, _ := s.QueryAssetNumberByPeriod(ctx, periodo-1)
	// 	if num != numero_contratos {
	// 		err = ErrNoPeriod
	// 		return
	// 	}
	// }
	ppa_client, err := s.QueryIdentityHistory(ctx, farmer)
	for _, rango_client := range ppa_client {
		if rango_client.Period == periodo && rango_client.Client == farmer {
			err = ErrFarmerPeriod
			return
		}
	}
	ppaKey, err := ctx.GetStub().CreateCompositeKey("payment", []string{farmer})
	if err != nil {
		return
	}
	var ppa *PPA
	var payments float64
	if periodo == 1 {
		var ppaOldEnergy [years * months]float64
		var ppaOldPayments [years * months]float64
		var l int
		var r float64
		for l, r = range energy {
			payments := r * precio_kwh
			payments = math.Round(payments*100) / 100
			ppaOldEnergy[periodo-1+l] = r
			ppaOldPayments[periodo-1+l] = payments
		}
		var de_fault bool
		if r == 0.0 {
			de_fault = true
		} else {
			de_fault = false
		}

		ppa = &PPA{
			DocType:  "ppa",
			Client:   farmer,
			Energy:   ppaOldEnergy,
			Payments: ppaOldPayments,
			Default:  de_fault,
			Period:   tiempo_cupon * periodo,
			Fecha: Datos{
				Day:   time.Now().Day(),
				Month: time.Now().Month(),
				Year:  time.Now().Year(),
			},
		}
	} else {
		var ppaOld *PPA
		ppaKey, err = ctx.GetStub().CreateCompositeKey("payment", []string{farmer})
		if err != nil {
			return
		}
		ppaOld, err = s.QueryAssetByID(ctx, ppaKey)
		if err != nil {
			return
		}

		// var ppaOldEnergy [years * months]float64
		// var ppaOldPayments [years * months]float64
		var l int
		var r float64
		for l, r = range energy {
			payments := r * precio_kwh
			payments = math.Round(payments*100) / 100
			ppaOld.Energy[periodo-1+l] = r
			ppaOld.Payments[periodo-1+l] = payments

			// ppaOldEnergy[periodo-1+l] = r
			// ppaOldPayments[periodo-1+l] = payments
		}

		// payments = energy * precio_kwh
		// payments = math.Round(payments*100) / 100
		var de_fault bool
		if r == 0.0 {
			de_fault = true
		} else {
			de_fault = false
		}

		ppa = &PPA{
			DocType:  "ppa",
			Client:   farmer,
			Energy:   ppaOld.Energy,
			Payments: ppaOld.Payments,
			Default:  de_fault,
			Period:   tiempo_cupon + periodo - 1,
			Fecha: Datos{
				Day:   time.Now().Day(),
				Month: time.Now().Month(),
				Year:  time.Now().Year(),
			},
		}

	}
	ppaAsBytes, err := json.Marshal(&ppa)
	//si no quiero validar el err, defino como elemento, _ :=json.Marshal()
	if err != nil {
		return
		// fmt.Printf("Marshal error: %s", err.Error())
		// return shim.Error("Expecting integer value for asset holding")
		// return err
	}

	// /////////////////////////////////////////
	// /////////////////////////////////////////
	// //OJO ESTO ESTA COMENTADO EN CASO NORMAL
	// //descomentar para probar la performance de la red
	// //////////////////////////////////////////
	// ////////////////////////////////////////
	// ppaKey = ctx.GetStub().GetTxID()
	err = ctx.GetStub().PutState(ppaKey, ppaAsBytes)
	if err != nil {
		return
		// return shim.Error("Expecting integer value for asset holding")
		// return fmt.Errorf("Error al subir: %v", err)
	}
	transientMap, err := ctx.GetStub().GetTransient()
	if err != nil {
		return
		// return shim.Error("Expecting integer value for asset holding")
		// return fmt.Errorf("Error al subir: %v", err)
	}
	err = PutFarmerPrivateData(ctx, transientMap)
	if err != nil {
		return
	}
	payload = WritePaymentsPayload{
		Client:   farmer,
		Payments: payments,
		Date:     ppa.Fecha,
		Code:     "payments",
	}
	return
}

//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//#############################################Funciones de consulta usando INDEXES#####################################################
//###################################################SOLO VALIDO CON COUCHDB############################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
//######################################################################################################################################
func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface) ([]*PagosImpagos, error) {
	var assets []*PagosImpagos
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset PPA
		var Pagos PagosImpagos
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		pagos := asset.Payments
		impagos := asset.Default
		Pagos.Payments = pagos
		Pagos.Default = impagos
		assets = append(assets, &Pagos)
	}

	return assets, nil
}

func constructQueryRequestFromIteratorID(resultsIterator shim.StateQueryIteratorInterface) ([]*Request, error) {
	var assets []*Request
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset Request
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}

func constructQueryResponseFromIteratorID(resultsIterator shim.StateQueryIteratorInterface) ([]*FarmerID, error) {
	var assets []*FarmerID
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset FarmerID
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}

func constructQueryResponseFromIteratorMapID(resultsIterator shim.StateQueryIteratorInterface) (*NewFarmerID, error) {
	var assets *NewFarmerID
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		// var asset NewFarmerID
		err = json.Unmarshal(queryResult.Value, assets)
		if err != nil {
			return nil, err
		}
		// assets = &asset
	}
	return assets, nil
}

func constructQueryResponseFromIteratorRequestID(resultsIterator shim.StateQueryIteratorInterface) ([]*FarmerID, error) {
	var assets []*FarmerID
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset Request
		var asset2 FarmerID
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		asset2.Identidad = asset.Requester
		log.Printf("valor: %v", asset)
		assets = append(assets, &asset2)
	}
	return assets, nil
}

func constructQueryResponseFromIteratorFarmerID(resultsIterator shim.StateQueryIteratorInterface) ([]*FarmerID, error) {
	var assets []*FarmerID
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset PPA
		var asset2 FarmerID
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		asset2.Identidad = asset.Client
		// log.Printf("valor: %v", asset)
		assets = append(assets, &asset2)
	}
	return assets, nil
}

// func constructQueryResponseFromIteratorSPV(resultsIterator shim.StateQueryIteratorInterface) ([]*ValorTotal, error) {
// 	var assets []*ValorTotal
// 	for resultsIterator.HasNext() {
// 		queryResult, err := resultsIterator.Next()
// 		if err != nil {
// 			return nil, err
// 		}
// 		var asset ValorTotal
// 		err = json.Unmarshal(queryResult.Value, &asset)
// 		if err != nil {
// 			return nil, err
// 		}
// 		assets = append(assets, &asset)
// 	}

// 	return assets, nil
// }

func constructQueryResponseFromIteratorHistory(resultsIterator shim.StateQueryIteratorInterface) ([]*PPA, error) {
	var assets []*PPA
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset PPA
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}

func constructQueryResponseFromIteratorNumber(resultsIterator shim.StateQueryIteratorInterface) (int, error) {
	var contador int
	contador = 0
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return 0, err
		}
		var asset PPA
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return 0, err
		}
		contador = contador + 1
	}
	return contador, nil
}

func constructQueryResponseFromIteratorPayments(resultsIterator shim.StateQueryIteratorInterface) ([]*PagosImpagos, error) {
	var vector []*PagosImpagos
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset PPA
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		pagos := &PagosImpagos{
			Payments: asset.Payments,
			Default:  asset.Default,
		}
		vector = append(vector, pagos)
	}
	return vector, nil
}

func constructQueryResponseFromIteratorBondsForSale(resultsIterator shim.StateQueryIteratorInterface) ([]*ForSale, error) {
	var vector []*ForSale
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset ForSale
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		// x := asset.Valor
		vector = append(vector, &asset)
	}
	return vector, nil
}

func constructQueryResponseFromIteratorBond(resultsIterator shim.StateQueryIteratorInterface) ([]*State, error) {
	var vector []*State
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset State
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		// x := asset.Valor
		vector = append(vector, &asset)
	}
	return vector, nil
}

func constructQueryResponseFromIteratorToken(resultsIterator shim.StateQueryIteratorInterface) ([]*AnotherState, error) {
	var vector []*AnotherState
	for resultsIterator.HasNext() {
		queryResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var asset AnotherState
		err = json.Unmarshal(queryResult.Value, &asset)
		if err != nil {
			return nil, err
		}
		// x := asset.Valor
		vector = append(vector, &asset)
	}
	return vector, nil
}

func getQueryResultForQueryString(ctx contractapi.TransactionContextInterface, queryString string) ([]*PagosImpagos, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIterator(resultsIterator)
}

func getQueryResultForQueryStringID(ctx contractapi.TransactionContextInterface, queryString string) ([]*FarmerID, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorID(resultsIterator)
}

func getQueryResultForQueryStringMapID(ctx contractapi.TransactionContextInterface, queryString string) (*NewFarmerID, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorMapID(resultsIterator)
}

func getQueryRequestForQueryStringID(ctx contractapi.TransactionContextInterface, queryString string) ([]*Request, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryRequestFromIteratorID(resultsIterator)
}

func getQueryResultForQueryStringHistory(ctx contractapi.TransactionContextInterface, queryString string) ([]*PPA, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorHistory(resultsIterator)
}

// func getQueryResultForQueryStringSPV(ctx contractapi.TransactionContextInterface, queryString string) ([]*ValorTotal, error) {

// 	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer resultsIterator.Close()
// 	return constructQueryResponseFromIteratorSPV(resultsIterator)
// }

func getQueryResultForQueryStringNumber(ctx contractapi.TransactionContextInterface, queryString string) (int, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return 0, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorNumber(resultsIterator)
}

func getQueryResultForQueryStringPayments(ctx contractapi.TransactionContextInterface, queryString string) ([]*PagosImpagos, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorPayments(resultsIterator)
}

func getQueryResultForQueryRequestID(ctx contractapi.TransactionContextInterface, queryString string) ([]*FarmerID, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorRequestID(resultsIterator)
}

func getQueryResultForQueryStringFarmerID(ctx contractapi.TransactionContextInterface, queryString string) ([]*FarmerID, error) {
	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorFarmerID(resultsIterator)
}

func getQueryResultForQueryStringBondsForSale(ctx contractapi.TransactionContextInterface, queryString string) ([]*ForSale, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorBondsForSale(resultsIterator)
}

func getQueryResultForBond(ctx contractapi.TransactionContextInterface, queryString string) ([]*State, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorBond(resultsIterator)
}

func getQueryResultForToken(ctx contractapi.TransactionContextInterface, queryString string) ([]*AnotherState, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()
	return constructQueryResponseFromIteratorToken(resultsIterator)
}

func (s *SmartContract) QueryAssetNumberByPeriod(ctx contractapi.TransactionContextInterface, periodo int) (int, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","periodo":%d}}`, periodo)

	return getQueryResultForQueryStringNumber(ctx, queryString)
}

func (s *SmartContract) QueryAssetByPeriod(ctx contractapi.TransactionContextInterface, periodo int) ([]*PagosImpagos, error) {
	valor := false
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","default":%t,"periodo":%d}}`, valor, periodo)

	return getQueryResultForQueryString(ctx, queryString)
}

func (s *SmartContract) QueryAssetDefaultByPeriod(ctx contractapi.TransactionContextInterface, periodo int) ([]*PagosImpagos, error) {
	valor := true
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","default":%t,"periodo":%d}}`, valor, periodo)

	return getQueryResultForQueryString(ctx, queryString)
}

// func (s *SmartContract) QueryAssetByPeriodSPV(ctx contractapi.TransactionContextInterface) ([]*ValorTotal, error) {
// 	queryString := fmt.Sprintf(`{"selector":{"docType":"cantidad"}}`)

// 	return getQueryResultForQueryStringSPV(ctx, queryString)
// }

func (s *SmartContract) QueryIdentities(ctx contractapi.TransactionContextInterface) ([]*FarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"identidad"}}`)

	return getQueryResultForQueryStringID(ctx, queryString)
}

func (s *SmartContract) QueryMapIdentities(ctx contractapi.TransactionContextInterface) (*NewFarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"identidad"}}`)

	return getQueryResultForQueryStringMapID(ctx, queryString)
}

func (s *SmartContract) QueryRequests(ctx contractapi.TransactionContextInterface, client string) ([]*Request, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"request","bonista":"%s"}}`, client)
	return getQueryRequestForQueryStringID(ctx, queryString)
}

func (s *SmartContract) QueryIdentitiesSPV(ctx contractapi.TransactionContextInterface) ([]*FarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"SPVidentidad"}}`)
	return getQueryResultForQueryStringID(ctx, queryString)
}

func QueryIdentitiesSPV(ctx contractapi.TransactionContextInterface) ([]*FarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"SPVidentidad"}}`)
	return getQueryResultForQueryStringID(ctx, queryString)
}

func (s *SmartContract) QueryIdentityHistory(ctx contractapi.TransactionContextInterface, farmer string) ([]*PPA, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","client":"%s"}}`, farmer)

	return getQueryResultForQueryStringHistory(ctx, queryString)
}

// func (s *SmartContract) QueryAssets(ctx contractapi.TransactionContextInterface, queryString string) ([]*PPA, error) {
// 	return getQueryResultForQueryString(ctx, queryString)
// }

func (s *SmartContract) QueryAssetByID(ctx contractapi.TransactionContextInterface, ppaID string) (*PPA, error) {
	ppaAsBytes, err := ctx.GetStub().GetState(ppaID)
	if err != nil {
		return nil, fmt.Errorf("failed to get ppa %s: %v", ppaID, err)
	}
	if ppaAsBytes == nil {
		return nil, fmt.Errorf("ppa %s does not exist", ppaID)
	}
	var ppa PPA
	err = json.Unmarshal(ppaAsBytes, &ppa)
	if err != nil {
		return nil, err
	}
	return &ppa, nil
}

func (s *SmartContract) QueryPaymentsAndDefaultByPeriod(ctx contractapi.TransactionContextInterface, periodo int) ([]*PagosImpagos, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","periodo":%d}}`, periodo)
	return getQueryResultForQueryStringPayments(ctx, queryString)
}

func (s *SmartContract) QueryRequesterID(ctx contractapi.TransactionContextInterface) ([]*FarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"request"}}`)
	return getQueryResultForQueryRequestID(ctx, queryString)
}

func (s *SmartContract) QueryBond(ctx contractapi.TransactionContextInterface) ([]*State, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"utxoBond"}}`)
	return getQueryResultForBond(ctx, queryString)
}

func (s *SmartContract) QueryToken(ctx contractapi.TransactionContextInterface) ([]*AnotherState, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"utxoToken"}}`)
	return getQueryResultForToken(ctx, queryString)
}

func (s *SmartContract) QueryFarmerIDByPeriod(ctx contractapi.TransactionContextInterface, periodo int) ([]*FarmerID, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"ppa","periodo":%d}}`, periodo)
	return getQueryResultForQueryStringFarmerID(ctx, queryString)
}

func (s *SmartContract) QueryBondsForSale(ctx contractapi.TransactionContextInterface) ([]*ForSale, error) {
	queryString := fmt.Sprintf(`{"selector":{"docType":"forsale"}}`)
	return getQueryResultForQueryStringBondsForSale(ctx, queryString)
}

//y ya tenemos la funcion que nos permite guardar en la blockchain

//creo el metodo main
func main() {
	//levantamos un nuevo chaincode y le enviamos la estructura
	//SmartContract, que devuelve 2 valores
	SC := new(SmartContract)

	// SC.TransactionContextHandler = new(CustomTransactionContextInterface)
	SC.beforeTransaction = BeforeTransaction
	SC.afterTransaction = AfterTransaction

	chaincode, err := contractapi.NewChaincode(SC)
	//chaincode, err := contractapi.NewChaincode(new(SmartContract))
	//verificamos si hay algun error
	if err != nil {
		fmt.Printf("Error create ppa chaincode: %s", err.Error())
		panic(err.Error())
		//y terminaria la ejecucion del codigo
		// return
	}

	//verificamos si hay algun error al ejecutar esta funcion
	if err := chaincode.Start(); err != nil {
		panic(err.Error())
		// fmt.Printf("Error starting ppa chaincode: %s", err.Error())
	}
}

//Variables en las que se guardan todos los tipos de errores posibles.
var (
	ErrOldID                 = errors.New("This PPA's ID already exists")
	ErrAtraso                = errors.New("This PPA will be considered in default")
	ErrNumMax                = errors.New("Not on correct period or achieved max number of contracts")
	ErrWrongPeriod           = errors.New("You are searching in a wrong period")
	ErrNotAValidFormatClient = errors.New("Client name hasnt a valid format")
	ErrNoFarmer              = errors.New("The identity should be a farmer to execute the transaction")
	ErrNoOriginator          = errors.New("The identity should be an originator to execute the transaction")
	ErrNoSpv                 = errors.New("The identity should be a SPV to execute the transaction")
	ErrNoPeriod              = errors.New("You are not allowed to write in this period")
	ErrFarmerPeriod          = errors.New("This client has already submit a payment for this period")
	ErrNoUnderwritter        = errors.New("The identity should be an underwritter to execute the transaction")
	ErrWrongNumber           = errors.New("There are 5000 bonds")
	ErrNoSPV                 = errors.New("The identity should belong to the SPV to execute the transaction")
	ErrSPVBond               = errors.New("Bonds have already been issued")
	ErrFirstBond             = errors.New("Before any action spv has to issue bonds")
	ErrNoFunds               = errors.New("SPV doesnt own enough funds")
	ErrWrongTransFieldName   = errors.New("Wrong transient field")
	ErrEmptyTransFieldValue  = errors.New("Transient value is empty")
	ErrHasOu                 = errors.New("You havent got enough permissions")
	ErrIdentities            = errors.New("Identities dont match")
	ErrExecution             = errors.New("Execution error")
	ErrWrongOrg              = errors.New("This org cant do that")
)

//con Stub es como accedo al world state y al ledger

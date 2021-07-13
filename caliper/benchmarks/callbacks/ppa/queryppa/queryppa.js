/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

const logger = require("@hyperledger/caliper-core").CaliperUtils.getLogger(
  "Payments"
);

module.exports.info = "Query PPA callback";

const contractID = "securitizationcode";
const version = "v1.0";

// save the objects during init
let bc,
  ctx,
  minterIdentity,
  targetPeers;
  // investorpeer,
  // contador,
  // privateData;
/**
 * Initializes the workload module before the start of the round.
 * @param {BlockchainInterface} blockchain The SUT adapter instance.
 * @param {object} context The SUT-specific context for the round.
 * @param {object} args The user-provided arguments for the workload module.
 */
 module.exports.init = async (blockchain, context, args) => {
  bc = blockchain;
  ctx = context;
  minterIdentity = args.client;
  // investorpeer=Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser2Org));
  targetPeers =Array.from(
    ctx.networkInfo.getPeersOfOrganization(args.endorser1Org)
    ).concat(
      Array.from(ctx.networkInfo.getPeersOfOrganization(args.minterOrg)),
      Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser2Org))
    );
  try {
    // console.log(
    //   `Los targetPeers son ${targetPeers} y los clientes son ${minterIdentity}`
    // );
    console.log(
      `Los targetPeers son ${targetPeers} y los clientes son ${minterIdentity}`
    );
  } catch (error) {
    console.log(
      `Smart Contract threw with error: ${error}`
    );
  }
  // privateData = {
  //   mintPrivateData: Buffer.from(
  //     JSON.stringify({
  //       depositReference: args.depositReference,
  //       bank: args.depositBank,
  //     })
  //   ),
  // };
  logger.debug("Initialized workload module");
};

//esto es lo que se va a probar
module.exports.run = async () => {
  let txArgs = {
    // chaincodeFunction: "RegisteringFarmers",
    chaincodeFunction: "QueryAssetByPeriod",
    // chaincodeArguments: [1000.001],
    // transientMap: privateData,
    chaincodeArguments: [1],
    invokerIdentity: minterIdentity,
    targetPeers: targetPeers,
  };
  // contador=contador+1
  // console.log(
  //   `contador ${txCount}`
  //  );
  return bc.bcObj.invokeSmartContract(
    ctx,
    contractID,
    version,
    txArgs,
    100
  );
};

module.exports.end = async () => {
  logger.debug("Disposed of workload module");
};
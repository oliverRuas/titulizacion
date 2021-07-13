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

module.exports.info = "Transfer callback";

const contractID = "securitizationcode";
const version = "v1.0";

// save the objects during init
let bc,
  ctx,
  minterIdentity,
  targetPeers;
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
  targetPeers = Array.from(
    ctx.networkInfo.getPeersOfOrganization(args.minterOrg)
  ).concat(
    Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser1Org)),
    Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser2Org))
  );
  try {
    console.log(
      `Los targetPeers son ${targetPeers} y los clientes son ${minterIdentity}`
    );
  } catch (error) {
    console.log(
      `Smart Contract threw with error: ${error}`
    );
  }
  logger.debug("Initialized workload module");
};

//esto es lo que se va a probar
module.exports.run = async () => {
  let txArgs = {
    chaincodeFunction: "Transfer",
    chaincodeArguments: ["[\"c1d19644fb186e74e2942e83edaa46884a278654d8bec2273e0223efc58873ab.0\"]",500,"eDUwOTo6Q049aW52ZXN0b3ItY2xpZW50LTEsT1U9Y2xpZW50K09VPWludmVzdG9yK09VPWNsaWVudGUsTz1JbnZlc3RvcixMPUludmVzdG9yTG9jYXRpb24sU1Q9SW52ZXN0b3JTdGF0ZSxDPVNQOjpDTj1yb290Y2EtaW52ZXN0b3IsT1U9SHlwZXJsZWRnZXIgRmFicmljLE89SW52ZXN0b3IsTD1JbnZlc3RvckwsU1Q9SW52ZXN0b3JTVCxDPVNQ"],
    invokerIdentity: minterIdentity,
    targetPeers: targetPeers,
  };
  
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
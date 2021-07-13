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
  "Request"
);

module.exports.info = "Request callback";

const contractID = "securitizationcode";
const version = "v1.0";

// save the objects during init
let bc,
  ctx,
  minterIdentity,
  targetPeers,
  privateData;
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

  // targetPeers = Array.from(
  //   ctx.networkInfo.getPeersOfOrganization(args.minterOrg)
  // )[0].concat(
  //   Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser1Org)),
  //   Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser2Org))
//    Array.from(ctx.networkInfo.getPeersOfOrganization(args.endorser3Org))
  // );
  try {
    console.log(
      `Los targetPeers son ${targetPeers}`
    );
  } catch (error) {
    console.log(
      `Smart Contract threw with error: ${error}`
    );
  }
  privateData = {
    mintPrivateData: Buffer.from(
      JSON.stringify({
        depositReference: args.depositReference,
        bank: args.depositBank,
      })
    ),
  };
  logger.debug("Initialized workload module");
};

//esto es lo que se va a probar
module.exports.run = async () => {
  let txArgs = {
    // chaincodeFunction: "RegisteringFarmers",
    chaincodeFunction: "RequestBond",
    chaincodeArguments: [20,"097f7cf68284daa95867808ec3551806c5fd7b7ef1b9e55043fa4283320db754"],
    transientMap: privateData,
    // chaincodeArguments: [],
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
//100 es un timeout
module.exports.end = async () => {
  logger.debug("Disposed of workload module");
};
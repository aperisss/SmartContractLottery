const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const {verify} = require("../helper-hardhat-config")

const VRF_SUB_FUND_AMOUNT = ethers.parseEther("2");

module.exports = async function ({getNamedAccounts, deployments}) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    let vrfCoordinatorV2Address, subscriptionId
    if (developmentChains.includes(network.name)) {
     const vrfCoordinatorV2MockDeployment = await deployments.get("VRFCoordinatorV2Mock");
     const vrfCoordinatorV2Mock = await ethers.getContractAt("VRFCoordinatorV2Mock", vrfCoordinatorV2MockDeployment.address);
      vrfCoordinatorV2Address = vrfCoordinatorV2Mock.target
      const transactionResponse = await vrfCoordinatorV2Mock.createSubscription()
      const transactionReceipt = await transactionResponse.wait(1);
      subscriptionId = 1
      await vrfCoordinatorV2Mock.fundSubscription(subscriptionId, VRF_SUB_FUND_AMOUNT)
    } else {
         vrfCoordinatorV2Address = network.config[chainId]["vrfCoordinatorv2"]
         subscriptionId = networkConfig[chainId]["subscriptionId"]
    }
    const entranceFee = networkConfig[chainId]["entranceFee"]
    const GasLane = networkConfig[chainId]["gasLane"]
    const callbackGasLimit = networkConfig[chainId]["callbackGasLimit"]
    const interval = networkConfig[chainId]["interval"]
    const args = [vrfCoordinatorV2Address, entranceFee, GasLane, subscriptionId, callbackGasLimit, interval]
     const raffle = await deploy("Raffle", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
     })
     if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
      log("Verifying...")
      await verify(raffle.address, args)
     }
     log("----------------------------")
}

module.exports.tags = ["all", "raffle"]
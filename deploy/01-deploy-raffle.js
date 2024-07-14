module.exports = async function ({getNamedAccounts, deployments}) {
    const { deploy, log } = deployments
    const { deployer } = getNamedAccounts()

     const raffle = await deploy("Raffle", {
        from:
     })
}
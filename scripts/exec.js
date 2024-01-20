require("dotenv").config();
const hre = require("hardhat");

const contractAddress = "0x2e285201E2BC6b5AA17c5829E6d80d5f6022d809";

async function main() {
	const signer = new hre.ethers.Wallet(process.env.SIGNER);
  const sender = new hre.ethers.Wallet(process.env.SENDER);

	const ContractFactory = await ethers.getContractFactory("UltimateFaceOff");
  const contract = ContractFactory.attach(contractAddress);

	const blockTime = parseInt((await ethers.provider.getBlock()).timestamp);
	console.log('block timestamp: ', blockTime);

  // console.log("provider: ", hre.ethers.provider);
  console.log("signer: ", signer.address);
  console.log("sender: ", sender.address);

  const message = hre.ethers.keccak256(
    hre.ethers.solidityPacked(
      ["address", "string"],
      [sender.address, "calyptus"]
    )
  );
  console.log("message: ", message);
	const arrayifyData = hre.ethers.getBytes(message)
  const signature = await signer.signMessage(arrayifyData);
  console.log("signature: ", signature);

	const tx = await contract.participate(signature);
  await tx.wait();
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .then(() => {});

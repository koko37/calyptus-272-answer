const { ethers } = require("ethers");
const abi = new ethers.AbiCoder();

async function main() {
  console.log("start to search new address!");

  let nonce = 87000;
  for (;;) {
    const signer = ethers.keccak256(
      abi.encode(["string", "uint256"], ["find", nonce])
    );
    const account = new ethers.Wallet(signer);

    if (account.address.startsWith("0xface")) {
      console.log(
        "nonce: ",
        nonce,
        " \taddress: ",
        account.address,
        " \tsigner: ",
        signer
      );
      break;
    }

    if (nonce % 10000 == 0) {
      console.log("till: ", nonce);
    }
    nonce++;
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .then(() => {
    console.log("Finished!");
  });

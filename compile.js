const fs = require("fs");
const solc = require("solc");

const input = fs.readFileSync("Exchange.sol", "utf8");

const output = solc.compile(
  JSON.stringify({
    language: "Solidity",
    sources: {
      "Exchange.sol": {
        content: input,
      },
    },
    settings: {
      outputSelection: {
        "*": {
          "*": ["*"],
        },
      },
    },
  })
);

const { Exchange } = JSON.parse(output).contracts["Exchange.sol"];
fs.writeFileSync("Exchange.abi", JSON.stringify(Exchange.abi));
fs.writeFileSync("Exchange.bin", Exchange.evm.bytecode.object);

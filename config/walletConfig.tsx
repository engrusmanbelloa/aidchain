export const providerMetadata = {
  name: "ui",
  description:
    "Revolutionize charitable giving with our Celo-powered DApp, ensuring transparency, efficiency, and real impact. Connect wallets, track donations, and transform lives.",
  url: "",
  icons: ["./assets/images/icon.png"],
  redirect: {
    native: "myapp://",
    universal: "",
  },
};
// Cello testnet session params
export const sessionParams = {
  namespaces: {
    eip155: {
      methods: [
        "eth_sendTransaction",
        "eth_signTransaction",
        "eth_sign",
        "personal_sign",
        "eth_signTypedData",
      ],
      chains: ["eip155:44787"],
      events: ["chainChanged", "accountsChanged"],
      rpcMap: {},
    },
  },
};

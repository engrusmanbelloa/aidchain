import FontAwesome from "@expo/vector-icons/FontAwesome";
import { useFonts } from "expo-font";
import { SplashScreen, Stack } from "expo-router";
import { useEffect } from "react";
import { GluestackUIProvider, Text, Box, config } from "@gluestack-ui/react";
import { WalletConnectModal } from "@walletconnect/modal-react-native";
// import { useWalletConnectModal } from "@walletconnect/modal-react-native";
import "react-native-gesture-handler";
import { AuthStore } from "../config/store";
import { metadata } from "../config/walletConfig";
import AsyncStorage from "@react-native-async-storage/async-storage";
import {
  createWeb3Modal,
  defaultWagmiConfig,
  Web3Modal,
} from "@web3modal/wagmi-react-native";
import { WagmiConfig, useAccount } from "wagmi";
import { mainnet, polygon, arbitrum } from "wagmi/chains";
import * as Clipboard from "expo-clipboard";

// wallet modal configuration
const projectId =
  process.env.EXPO_PROJECT_ID || "d2127653862c1e78e871be33956cf6e4";
const chains = [mainnet, polygon, arbitrum];
const wagmiConfig = defaultWagmiConfig({ chains, projectId, metadata });

// Create modal
createWeb3Modal({
  projectId,
  chains,
  wagmiConfig,
  defaultChain: mainnet,
  clipboardClient: {
    setString: async (value: string) => {
      await Clipboard.setStringAsync(value);
    },
  },
});

export {
  // Catch any errors thrown by the Layout component.
  ErrorBoundary,
} from "expo-router";

// export const unstable_settings = {
//   // Ensure that reloading on `/modal` keeps a back button present.
//   initialRouteName: "(auth)",
// };

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const { isLoggedIn } = AuthStore.useState((s) => s);
  AsyncStorage.clear();
  const [loaded, error] = useFonts({
    SpaceMono: require("../assets/fonts/SpaceMono-Regular.ttf"),
    ...FontAwesome.font,
  });

  // Expo Router uses Error Boundaries to catch errors in the navigation tree.
  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return (
    <WagmiConfig config={wagmiConfig}>
      <RootLayoutNav isLogged={isLoggedIn} />
      <Web3Modal />
    </WagmiConfig>
  );
}

function RootLayoutNav({ isLogged }: any) {
  const { address, isConnecting, isDisconnected, isConnected } = useAccount();
  return (
    <GluestackUIProvider config={config.theme}>
      <Stack>
        {isLogged && isConnected ? (
          <Stack.Screen name="(drawer)" options={{ headerShown: false }} />
        ) : (
          <Stack.Screen name="(auth)" options={{ headerShown: false }} />
        )}
      </Stack>
    </GluestackUIProvider>
  );
}

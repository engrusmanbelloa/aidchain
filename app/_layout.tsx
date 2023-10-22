import FontAwesome from "@expo/vector-icons/FontAwesome";
import { useFonts } from "expo-font";
import { SplashScreen, Stack } from "expo-router";
import { useEffect } from "react";
import { GluestackUIProvider, Text, Box, config } from "@gluestack-ui/react";
import { WalletConnectModal } from "@walletconnect/modal-react-native";
import { useWalletConnectModal } from "@walletconnect/modal-react-native";
import "react-native-gesture-handler";
import { AuthStore } from "../config/store";
import { providerMetadata } from "../config/walletConfig";
import AsyncStorage from "@react-native-async-storage/async-storage";

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

  return <RootLayoutNav isLogged={isLoggedIn} />;
}

function RootLayoutNav({ isLogged }: any) {
  const { isOpen, open, close, provider, isConnected, address } =
    useWalletConnectModal();
  return (
    <GluestackUIProvider config={config.theme}>
      <Stack>
        {isLogged && isConnected ? (
          <Stack.Screen name="(drawer)" options={{ headerShown: false }} />
        ) : (
          // <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
          <Stack.Screen name="(auth)" options={{ headerShown: false }} />
        )}
      </Stack>
      <WalletConnectModal
        projectId="d2127653862c1e78e871be33956cf6e4"
        providerMetadata={providerMetadata}
        accentColor="#042a2b"
      />
    </GluestackUIProvider>
  );
}

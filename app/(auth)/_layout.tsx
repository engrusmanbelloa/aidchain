import { Stack, useRouter, useRootNavigation } from "expo-router";
import { Button } from "react-native";
import { useEffect, useState } from "react";
import { AuthStore } from "../../config/store";

const AuthLayout = () => {
  const router = useRouter();
  const { isLoggedIn } = AuthStore.useState((s) => s);
  const rootNavigation = useRootNavigation();
  const [isLoading, setIsLoading] = useState(true);

  // if (isLoggedIn) {
  //   // Redirect to the tabs route if isLoggedIn is true
  //   router.replace("/tabs");
  //   return null; // Return null to prevent rendering the auth screens
  // }

  useEffect(() => {
    const checkIfReady = async () => {
      const isReady = rootNavigation?.isReady();
      if (isReady && isLoggedIn) {
        setIsLoading(false);
        router.replace("/(drawer)/(tabs)");
        return null; // Return null to prevent rendering the auth screens
      }
    };

    checkIfReady();
    const intervalId = setInterval(checkIfReady, 1000); // Check every second

    return () => {
      clearInterval(intervalId);
    };
  }, [rootNavigation]);

  return (
    <Stack>
      <Stack.Screen
        name="index"
        options={{ headerTitle: "Login", headerShown: false }}
      />
      <Stack.Screen
        name="signup"
        options={{
          headerTitle: "Sign Up",
          headerShown: false,
        }}
      />
    </Stack>
  );
};

export default AuthLayout;

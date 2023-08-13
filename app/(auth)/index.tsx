import { useState, useEffect, ChangeEvent } from "react";
import { AuthStore } from "../../config/store";
import { KeyboardAvoidingView } from "react-native";
import { Stack, useRouter } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";
import styled from "styled-components/native";
import { Ionicons } from "@expo/vector-icons";
import {
  GluestackUIProvider,
  Text,
  Box,
  config,
  Pressable,
  Input,
  VStack,
  HStack,
  Button,
  Modal,
  Link,
} from "@gluestack-ui/react";

const Container = styled(SafeAreaView)`
  flex: 1;
  background: #042a2b;
`;
const Title = styled(Text)`
  color: #fff;
  position: absolute;
  top: 100px;
  left: 15px;
  width: 50%;
  font-size: 40px;
  font-weight: 700;
  line-height: 50px;
`;
const Main = styled(KeyboardAvoidingView)`
  background: #fff;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  top: 25%;
  border-radius: 30px;
  padding: 10px;
`;
const LoginStack = styled(VStack)`
  bottom: 22%;
  width: 90%;
`;
const ContinueStack = styled(VStack)`
  width: 100%;
  height: 50px;
  bottom: 15%;
  justify-content: center;
  align-items: center;
`;
const Hrule = styled(Box)`
  top: 10%;
  border: 1px solid #228b22;
  width: 100%;
  height: 0.5px;
`;
const Continue = styled(Text)`
  bottom: 15%;
  width: 40%;
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  background: #fff;
  color: #0e32b4;
`;
const SocialLogins = styled(VStack)`
  top: 5%;
  width: 25%;
  justify-content: space-around;
`;
const SignUpBox = styled(Text)`
  bottom: 8%;
  color: #000;
  font-size: 14px;
  font-weight: 600;
  line-height: 16px;
  letter-spacing: 1px;
  background: transparent;
`;
const SignUp = styled(Link)`
  color: #0e32b4;
  font-size: 14px;
  font-weight: 600;
  text-decoration: underline;
`;

export default function SingInScreen() {
  const router = useRouter();
  const [show, setShow] = useState(false);
  const [walletConnected, setwalletConnected] = useState(true);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const { isLoggedIn, hasVerifed } = AuthStore.useState((s) => s);
  const login = () => {
    // Login logic when password is entered
    if (walletConnected) {
      AuthStore.update((s) => {
        s.isLoggedIn = true;
        router.replace("/(tabs)");
      });
    } else {
      showModal();
      // shhow modal to cannect wallet
    }
  };

  const showModal = () => {
    setIsModalVisible(true);
  };

  const handleSignUp = () => {
    AuthStore.update((s) => {
      s.isLoggedIn = false;
    });
    router.push("/register");
  };

  const handleLogin = () => {
    setwalletConnected(true);
  };

  const handleIcon = () => {};

  return (
    <Container>
      <Box>
        {/* <Stack.Screen options={{ title: "Login" }} /> */}
        <Title>Welcome Back</Title>
        <Main>
          <ContinueStack>
            <Continue>continue with</Continue>
            <SocialLogins>
              <Ionicons name="logo-google" size={34} color="#DB4437" />
              <Ionicons name="ios-logo-apple" size={34} color="#555555" />
            </SocialLogins>
            <Pressable onPress={login}>
              <Text>Login</Text>
            </Pressable>
          </ContinueStack>
          {/* <SignUpBox >
            Don't have an account?&nbsp;
            <SignUp href="/signup" onPress={handleSignUp} isHovered>
              Sign up
            </SignUp>
          </SignUpBox> */}
        </Main>
      </Box>
    </Container>
  );
}

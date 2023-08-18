import { useState, useEffect, ChangeEvent } from "react";
import { AuthStore } from "../../config/store";
import { KeyboardAvoidingView, StatusBar, AppState } from "react-native";
import { Stack, useRouter } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";
import styled from "styled-components/native";
import { Ionicons } from "@expo/vector-icons";
import { useWalletConnectModal } from "@walletconnect/modal-react-native";
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
  color: #eef4f2;
  position: absolute;
  top: 80px;
  left: 15px;
  width: 50%;
  font-size: 40px;
  font-weight: 700;
  line-height: 50px;
`;
const Main = styled(KeyboardAvoidingView)`
  background: #eef4f2;
  alignitems: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  top: 30%;
  border-radius: 30px;
  padding: 10px;
`;
const ContinueStack = styled(VStack)`
  width: 80%;
  height: 50px;
  bottom: 15%;
  justify-content: center;
  margin: auto;
`;
const Continue = styled(Text)`
  margin-bottom: 25px;
  left: 0px;
  width: 40%;
  font-size: 20px;
  font-weight: 600;
  color: #042a2b;
`;
const SocialLogins = styled(VStack)`
  width: 100%;
  justify-content: center;
  align-items: center;
`;
const SignInBox = styled(Pressable)`
  background: #042a2b;
  width: 100%;
  height: 40px;
  justify-content: center;
  align-items: center;
  border-radius: 50px;
  margin-bottom: 10px;
  cursor: pointer;
`;
const LoginTxt = styled(Text)`
  color: #eef4f2;
  left: 5px;
  font-size: 16px;
  font-weight: 400;
`;
const SignUpBox = styled(Pressable)`
  justify-content: center;
  align-items: center;
`;
const SignUp = styled(Link)``;
const SignUpTxt = styled(Text)`
  color: #0e32b4;
  font-size: 14px;
  font-weight: 600;
  text-decoration: underline;
  left: 5px;
`;
const ModalBox = styled(Modal)`
  top: 50%;
`;
// background: #eef4f2;
const ModalLogin = styled(VStack)`
  background: #cdbda9;
  width: 100%;
  height: 90%;
  border-radius: 15px;
`;
const ModalStack = styled(VStack)`
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 50%;
`;
const ModalTex = styled(Text)`
  top: 25px;
  left: 25px;
  font-size: 25px;
  font-weight: 500;
  color: #042a2b;
  line-height: 25px;
`;
const Connect = styled(Pressable)`
  background-color: #042a2b;
  width: 80%;
  height: 40px;
  justify-content: center;
  align-items: center;
  border-radius: 50px;
`;
const ConnectTxt = styled(Text)`
  font-size: 16px;
  font-weight: 500;
  color: #eef4f2;
`;
const ModalCancel = styled(Text)`
  position: absolute;
  bottom: 15%;
  color: #0e32b4;
`;

export default function SingInScreen() {
  const router = useRouter();
  const [show, setShow] = useState(false);
  const [walletConnected, setwalletConnected] = useState(false);
  const { isOpen, open, close, provider, isConnected, address } =
    useWalletConnectModal();
  const [isModalVisible, setIsModalVisible] = useState(false);
  const { isLoggedIn, hasVerifed } = AuthStore.useState((s) => s);
  const mode = "light-content";
  const login = () => {
    // Login logic when password is entered
    if (isConnected) {
      AuthStore.update((s) => {
        s.isLoggedIn = true;
        router.replace("/(tabs)");
      });
      // console.log("Connected wallet address:", provider, address);
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
    router.push("/(auth)/signup");
  };

  return (
    <Container>
      <StatusBar barStyle={mode} />
      <Box>
        <Title>Welcome Back</Title>
        <Main>
          <ContinueStack>
            <Continue>Login with</Continue>
            <SocialLogins>
              <SignInBox onPress={login}>
                <HStack alignItems="center">
                  <Ionicons name="logo-google" size={18} color="#DB4437" />
                  <LoginTxt>Login with google</LoginTxt>
                </HStack>
              </SignInBox>
              <SignInBox onPress={login}>
                <HStack alignItems="center">
                  <Ionicons name="ios-logo-apple" size={20} color="#ffffff" />
                  <LoginTxt>Login with iPhone</LoginTxt>
                </HStack>
              </SignInBox>
            </SocialLogins>
          </ContinueStack>
          <SignUpBox>
            <HStack>
              <Text color="#042a2b">Don't have an account?&nbsp;</Text>
              <SignUp onPress={handleSignUp} isHovered>
                <SignUpTxt>Sign up</SignUpTxt>
              </SignUp>
            </HStack>
          </SignUpBox>
        </Main>
        <ModalBox
          isOpen={isModalVisible}
          onClose={() => setIsModalVisible(false)}
        >
          <ModalLogin>
            <ModalTex>Connect wallet</ModalTex>
            <ModalStack>
              <Connect onPress={open}>
                <ConnectTxt>{isConnected ? "Connected" : "Connect"}</ConnectTxt>
              </Connect>
              <ModalCancel onPress={() => setIsModalVisible(false)}>
                Cancel
              </ModalCancel>
            </ModalStack>
          </ModalLogin>
        </ModalBox>
      </Box>
    </Container>
  );
}

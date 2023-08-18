import { useState, useEffect, ChangeEvent } from "react";
import { AuthStore } from "../../config/store";
import { KeyboardAvoidingView, StatusBar } from "react-native";
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
  width: 100%;
  height: 50px;
  bottom: 15%;
  justify-content: center;
  align-items: center;
`;
const Continue = styled(Text)`
  margin-bottom: 25px;
  left: -70px;
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
  width: 80%;
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
const SignUp = styled(Pressable)``;
const SignUpTxt = styled(Text)`
  color: #0e32b4;
  font-size: 14px;
  font-weight: 600;
  text-decoration: underline;
  left: 5px;
`;

export default function SingUpScreen() {
  const router = useRouter();
  const [show, setShow] = useState(false);
  const [accountSuccess, setaccountSuccess] = useState(false);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const { isLoggedIn, hasVerifed } = AuthStore.useState((s) => s);
  const mode = "light-content";
  const signup = () => {
    // Login logic when password is entered
    if (!accountSuccess) {
      AuthStore.update((s) => {
        s.isLoggedIn = true;
        router.push("/index)");
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
    router.push("/(auth)");
  };

  return (
    <Container>
      <StatusBar
        barStyle={mode}
        // barStyle={mode === "light" ? "dark-content" : "light-content"}
        // backgroundColor={
        //   mode === "light" ? themes[theme].secondaryColor : "#000"
        // }
      />
      <Box>
        <Title>Create Account</Title>
        <Main>
          <ContinueStack>
            <Continue>Join with</Continue>
            <SocialLogins>
              <SignInBox onPress={signup}>
                <HStack alignItems="center">
                  <Ionicons name="logo-google" size={18} color="#DB4437" />
                  <LoginTxt>Sing up with google</LoginTxt>
                </HStack>
              </SignInBox>
              <SignInBox onPress={signup}>
                <HStack alignItems="center">
                  <Ionicons name="ios-logo-apple" size={20} color="#ffffff" />
                  <LoginTxt>Sign up with iPhone</LoginTxt>
                </HStack>
              </SignInBox>
            </SocialLogins>
          </ContinueStack>
          <SignUpBox>
            <HStack>
              <Text color="#042a2b">Already have an account?&nbsp;</Text>
              <SignUp onPress={handleSignUp}>
                <SignUpTxt>Sign In</SignUpTxt>
              </SignUp>
            </HStack>
          </SignUpBox>
        </Main>
      </Box>
    </Container>
  );
}

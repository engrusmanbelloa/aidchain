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
  left: 15px;
  font-size: 20px;
  font-weight: 600;
`;

export default function TabTwoScreen() {
  return (
    <Container>
      <StatusBar barStyle="light-content" />
      <Title>Profile screen</Title>
    </Container>
  );
}

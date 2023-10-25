import { useState, useEffect, ChangeEvent } from "react";
import { Ionicons } from "@expo/vector-icons";
import { Tabs, useRouter } from "expo-router";
import { useWalletConnectModal } from "@walletconnect/modal-react-native";
import { useNavigation, DrawerActions } from "@react-navigation/native";
import styled from "styled-components/native";
import { useAccount } from "wagmi";
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
  Image,
} from "@gluestack-ui/react";

const WalletConnect = styled(Pressable)`
  background-color: #eef4f2;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  height: 70%;
  right: 10px;
  border-radius: 50px;
  padding: 0px;
  box-sizing: border-box;
`;
const WalletTxt = styled(Box)`
  background-color: #5eb1bf;
  width: 70px;
  padding: 2px;
  border-radius: 50px;
  justify-content: center;
  align-items: center;
  margin-right: 5px;
`;
const WalletAd = styled(Text)`
  height: 100%;
  padding: 7px 0px;
  border-radius: 50px;
  font-size: 16px;
  font-weight: 600;
  text-align: center;
  margin-right: 5px;
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

function TabBarIcon(props: {
  name: React.ComponentProps<typeof Ionicons>["name"];
  color: string;
}) {
  return <Ionicons size={28} style={{ marginBottom: -3 }} {...props} />;
}

function AvatarHeader() {
  const navigation = useNavigation();
  return (
    <Pressable onPress={() => navigation.dispatch(DrawerActions.openDrawer())}>
      <Image
        source={{
          uri: "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
        }}
        style={{ width: 30, aspectRatio: 1, borderRadius: 40, marginLeft: 10 }}
      />
    </Pressable>
  );
}

export default function TabLayout() {
  const [isModalVisible, setIsModalVisible] = useState(false);
  const router = useRouter();
  const { provider } = useWalletConnectModal();
  const { address, isConnecting, isDisconnected, isConnected } = useAccount();
  const WalletAddress = address?.toString();
  const shortenedAddress =
    WalletAddress?.slice(0, 4) +
    "..." +
    WalletAddress?.slice(WalletAddress.length - 4);

  const OpenWalletOptions = async () => {
    if (isConnected) {
      setIsModalVisible(true);
      // console.log("Connected wallet address:", shortenedAddress);
    }
  };

  const disconnect = async () => {
    if (isConnected) {
      try {
        console.log("Provider", provider);
        await provider?.disconnect();
        setIsModalVisible(false);
        router.replace("/(auth)");
      } catch (error) {
        console.log("Disconnect error: ", error);
      }
    }
    router.replace("/(auth)");
  };

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: "#5EB1BF",
        tabBarStyle: {
          backgroundColor: "#042a2b",
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: "Home",
          headerStyle: {
            backgroundColor: "#042a2b",
          },
          headerTintColor: "#eef4f2",
          tabBarIcon: ({ color }) => (
            <TabBarIcon name="ios-home-outline" color={color} />
          ),
          headerRight: () => (
            <WalletConnect onPress={OpenWalletOptions}>
              <WalletTxt>
                <Ionicons name="wallet-outline" size={34} color="#042a2b" />
              </WalletTxt>
              <WalletAd>{shortenedAddress}</WalletAd>
              <ModalBox
                isOpen={isModalVisible}
                onClose={() => setIsModalVisible(false)}
              >
                <ModalLogin>
                  <ModalTex>Disconnect wallet</ModalTex>
                  <ModalStack>
                    <Connect onPress={disconnect}>
                      <ConnectTxt>
                        {isConnected ? "Disconect" : null}
                      </ConnectTxt>
                    </Connect>
                    <ModalCancel onPress={() => setIsModalVisible(false)}>
                      Cancel
                    </ModalCancel>
                  </ModalStack>
                </ModalLogin>
              </ModalBox>
            </WalletConnect>
          ),
          headerLeft: () => <AvatarHeader />,
        }}
      />
      <Tabs.Screen
        name="donations"
        options={{
          title: "Donations",
          headerStyle: {
            backgroundColor: "#042a2b",
          },
          headerTintColor: "#eef4f2",
          // headerShown: false,
          tabBarIcon: ({ color }) => (
            <TabBarIcon name="ios-file-tray-full-outline" color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: "Profile",
          headerStyle: {
            backgroundColor: "#042a2b",
          },
          headerTintColor: "#eef4f2",
          // headerShown: false,
          tabBarIcon: ({ color }) => (
            <TabBarIcon name="person-circle-outline" color={color} />
          ),
        }}
      />
    </Tabs>
  );
}

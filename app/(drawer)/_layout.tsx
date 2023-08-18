import { withLayoutContext } from "expo-router";
import {
  DrawerContentScrollView,
  DrawerItemList,
  createDrawerNavigator,
} from "@react-navigation/drawer";
import { ActivityIndicator } from "react-native";
import {
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

const DrawerNavigator = createDrawerNavigator().Navigator;

const Drawer = withLayoutContext(DrawerNavigator);

function CustomDrawerContent(props: any) {
  return (
    <DrawerContentScrollView {...props} style={{ backgroundColor: "#eef4f2" }}>
      <Text
        style={{
          alignSelf: "flex-start",
          fontSize: 20,
          left: 10,
          color: "#042a2b",
        }}
      >
        Usman Bello A.
      </Text>
      <DrawerItemList {...props} />
    </DrawerContentScrollView>
  );
}

export default function DrawerLayout() {
  return (
    <Drawer drawerContent={(props: any) => <CustomDrawerContent {...props} />}>
      <Drawer.Screen
        name="(tabs)"
        options={{ headerShown: false, title: "Home" }}
      />
    </Drawer>
  );
}

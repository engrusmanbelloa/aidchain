import { Store, registerInDevtools } from "pullstate";

interface AuthStore {
  isLoggedIn: boolean;
  hasEverLoggedIn: boolean;
  hasVerifed: boolean;
  hasAccount: boolean;
  isDarkMode: boolean;
}

export const AuthStore = new Store<AuthStore>({
  isLoggedIn: false,
  hasEverLoggedIn: false,
  hasVerifed: false,
  hasAccount: false,
  isDarkMode: true,
});

registerInDevtools({ AuthStore });

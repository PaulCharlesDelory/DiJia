// src/lib/auth.ts

export const AUTH_CREDENTIALS = {
  username: "loffirich",
  password: "cassiop8", // tu peux changer ça évidemment
};

export const isAuthenticated = () => {
  return localStorage.getItem("authenticated") === "true";
};

export const login = (username: string, password: string) => {
  if (
    username === AUTH_CREDENTIALS.username &&
    password === AUTH_CREDENTIALS.password
  ) {
    localStorage.setItem("authenticated", "true");
    return true;
  }
  return false;
};

export const logout = () => {
  localStorage.removeItem("authenticated");
};

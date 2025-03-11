import "./App.css";

import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { SidebarProvider } from "./components/ui/sidebar";
import { ConfigurationProvider } from "./providers/ConfigurationProvider";
import {withAuthenticationRequired} from 'react-oidc-context';

import Site404Page from "./features/core/Site404Page";
import ContactsPage from "./features/contacts/ContactsPage";
import SettingsPage from "./features/settings/SettingsPage";
import ErrorPage from "./features/core/ErrorPage";
import HomePage from "./features/home";
import { Toaster } from "./components/ui/toaster";

import { ComponentType } from "react";

export const AuthGuard = ({component}:{component: ComponentType})  => {
  const Component = withAuthenticationRequired(component);
  return <Component/>;
}

const router = createBrowserRouter([
  {
    path: "/",
    element: <AuthGuard component={() => <HomePage/>} />,
    errorElement: <ErrorPage />,
  },
  {
    path: "/contacts",
    element: <AuthGuard component={() => <ContactsPage/>} />,
    errorElement: <ErrorPage />,
  },
  {
    path: "/contacts/all",
    element: <AuthGuard component={() => <ContactsPage/>} />,
    errorElement: <ErrorPage />,
  },
  {
    path: "/settings",
    element: <AuthGuard component={() => <SettingsPage/>} />,
    errorElement: <ErrorPage />,
  },
  {
    path: "*",
    element: <Site404Page />,
  },
]);

export default function App() {
  return (
    <SidebarProvider>
      <ConfigurationProvider>
        <RouterProvider router={router}></RouterProvider>
        <Toaster />
      </ConfigurationProvider>
    </SidebarProvider>
  );
}

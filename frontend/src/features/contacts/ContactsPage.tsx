import { BreadCrumbItem } from "@/components/SideNav/model";

import Layout from "./../Layout";
import ContactsDataGrid from "./ContactList";
import useContactsGet from "./useContactsGet";

const breadCrumbs: BreadCrumbItem[] = [
  {
    title: "Home",
    url: "/",
  },
  {
    title: "Contacts",
    url: "/contacts",
  },
];

const ContactsPage = () => {
  const {response} = useContactsGet();

  return (
    <Layout titleToActivate="Contacts" breadcrumbs={breadCrumbs}>
      <Layout.Title>Contacts</Layout.Title>
      <ContactsDataGrid contacts={response ?? []} />
    </Layout>
  );
};

export default ContactsPage;

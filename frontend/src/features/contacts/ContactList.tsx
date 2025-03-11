import React, { useState, useEffect } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Label } from "@/components/ui/label"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Contact } from "./models"
import { PencilIcon } from "lucide-react"
import { useConfiguration } from "@/providers/ConfigurationProvider"


interface ContactsDataGridProps {
    contacts: Contact[]
}

const ContactsDataGrid:React.FC<ContactsDataGridProps> = ({contacts}) => {
  const [searchTerm, setSearchTerm] = useState("")
  const [currentPage, setCurrentPage] = useState(1)
  const [filteredContacts, setFilteredContacts] = useState<Contact[]>([])
  const {configuration} = useConfiguration()

  const ITEMS_PER_PAGE = configuration?.numberOfItemsPerPage ?? 15

  useEffect(() => {
    const filtered = contacts.filter((contact) =>
      Object.values(contact).some((value) => value.toLowerCase().includes(searchTerm.toLowerCase())),
    )
    setFilteredContacts(filtered)
    setCurrentPage(1)
  }, [contacts, searchTerm])

  const totalPages = Math.ceil(filteredContacts.length / ITEMS_PER_PAGE)
  const startIndex = (currentPage - 1) * ITEMS_PER_PAGE
  const endIndex = startIndex + ITEMS_PER_PAGE
  const currentContacts = filteredContacts.slice(startIndex, endIndex)

  const handleEdit = (id: string) => {
    console.log(`Edit contact with id: ${id}`)
    // Implement edit functionality here
  }

  return (
    <div className="container mx-auto p-4">
      <div className="mb-4">
        <Input
          type="text"
          placeholder="Search contacts..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full"
        />
      </div>

      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>ID</TableHead>
            <TableHead>First Name</TableHead>
            <TableHead>Last Name</TableHead>
            <TableHead>Email</TableHead>
            <TableHead>Street Address</TableHead>
            <TableHead>City</TableHead>
            <TableHead>Country</TableHead>
            <TableHead>Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {currentContacts.map((contact) => (
            <TableRow key={contact.id}>
              <TableCell>{contact.id}</TableCell>
              <TableCell>{contact.first_name}</TableCell>
              <TableCell>{contact.last_name}</TableCell>
              <TableCell>{contact.email}</TableCell>
              <TableCell>{contact.street_address}</TableCell>
              <TableCell>{contact.city}</TableCell>
              <TableCell>{contact.country}</TableCell>
              <TableCell>
              <button
                  onClick={() => handleEdit(contact.id)}
                  className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                  aria-label={`Edit ${contact.first_name} ${contact.last_name}`}
                >
                  <PencilIcon className="h-4 w-4" />
                </button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <div className="mt-4 flex justify-between items-center">
        <Label >
          Showing {startIndex + 1} to {Math.min(endIndex, filteredContacts.length)} of {filteredContacts.length} entries
        </Label >
        <div className="space-x-2">
          <Button onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))} disabled={currentPage === 1}>
            Previous
          </Button>
          <Button
            onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
            disabled={currentPage === totalPages}
          >
            Next
          </Button>
        </div>
      </div>
    </div>
  )
}

export default ContactsDataGrid

import React, { useState } from "react";
import AddAIForm from "../components/AddAIForm";
import AIList from "../components/AIList";
import EditAIModal from "../components/EditAIModal";
import type { AI } from "@/types";
import { useNavigate } from "react-router-dom";


export default function AdminDashboard() {
  const [selectedAI, setSelectedAI] = useState<AI | null>(null);
  const [openModal, setOpenModal] = useState(false);
  const [refresh, setRefresh] = useState(false); // pour forcer le rechargement
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("authenticated");
    navigate("/login");
  };


  const handleEdit = (ai: AI) => {
    setSelectedAI(ai);
    setOpenModal(true);
  };

  const handleUpdate = () => {
    setRefresh(!refresh); // change la valeur pour forcer le useEffect de AIList
    setOpenModal(false);  // ferme le modal
  };

  return (
    <div className="p-6">
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-2xl font-bold">Ajouter une IA</h1>
        <button
          onClick={handleLogout}
          className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
        >
          Déconnexion
        </button>
      </div>

      <AddAIForm />

      <h2 className="text-xl font-bold mt-10 mb-2">Liste des IA</h2>
      <AIList key={refresh.toString()} onEdit={handleEdit} />

      {openModal && selectedAI !== null && (
        <EditAIModal
          ai={selectedAI}
          onClose={() => setOpenModal(false)}
          onSave={handleUpdate}
          isOpen={openModal}
        />
      )}
    </div>
  );
}




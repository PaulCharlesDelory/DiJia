import React, { useState } from "react";
import AddAIForm from "@/components/AddAIForm";
import AIList from "@/components/AIList";
import EditAIModal from "@/components/EditAIModal";
import type { AI } from "@/types";

export default function AdminDashboard() {
  const [selectedAI, setSelectedAI] = useState<AI | null>(null);
  const [openModal, setOpenModal] = useState(false);
  const [refresh, setRefresh] = useState(false); // pour forcer le rechargement

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
      <h1 className="text-2xl font-bold mb-4">Ajouter une IA</h1>
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



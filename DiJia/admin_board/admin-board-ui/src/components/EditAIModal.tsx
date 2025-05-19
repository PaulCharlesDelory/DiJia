import React, { useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import type { AI } from "../types";

interface EditAIModalProps {
 isOpen: boolean;
  onClose: () => void;
  ai: AI | null; // car tu vérifies if (!ai) ensuite
  onSave: (updatedAI: AI) => void;
}

const EditAIModal: React.FC<EditAIModalProps> = ({ isOpen, onClose, ai, onSave }) => {
  if (!ai) return null;
  const [name, setName] = useState(ai.name);
  const [description, setDescription] = useState(ai.description);
  const [model, setModel] = useState(ai.model);
  const [avatarUrl, setAvatarUrl] = useState(ai.avatar_url);

  const handleSave = () => {
    const updatedAI = {
      id: ai.id,
      name,
      description,
      model,
      avatar_url: avatarUrl,
    };
    onSave(updatedAI);
    onClose();
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Modifier l&apos;IA</DialogTitle>
        </DialogHeader>
        <div className="space-y-4">
          <Label>Nom</Label>
          <Input value={name} onChange={(e) => setName(e.target.value)} />

          <Label>Description</Label>
          <Input value={description} onChange={(e) => setDescription(e.target.value)} />

          <Label>Modèle</Label>
          <Input value={model} onChange={(e) => setModel(e.target.value)} />

          <Label>Avatar URL</Label>
          <Input value={avatarUrl} onChange={(e) => setAvatarUrl(e.target.value)} />
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Annuler</Button>
          <Button onClick={handleSave}>Sauvegarder</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default EditAIModal;

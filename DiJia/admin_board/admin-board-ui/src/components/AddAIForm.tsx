import React, { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";

export default function AddAIForm() {
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [avatarUrl, setAvatarUrl] = useState("");
  const [model, setModel] = useState("gpt-3.5-turbo");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const payload = {
      name,
      description,
      avatar_url: avatarUrl,
      model,
    };

    const res = await fetch("http://localhost:8000/api/admin/add-ai", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    if (res.ok) {
      setMessage("✅ IA ajoutée avec succès !");
      setName("");
      setDescription("");
      setAvatarUrl("");
    } else {
      setMessage("❌ Erreur lors de l'ajout de l'IA.");
    }
  };

  return (
    <Card className="max-w-xl mx-auto mt-10 p-6">
      <CardContent>
        <h2 className="text-xl font-bold mb-4">Ajouter une nouvelle IA</h2>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <Label>Nom</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} required />
          </div>
          <div>
            <Label>Description</Label>
            <Input
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              required
            />
          </div>
          <div>
            <Label>Avatar (URL)</Label>
            <Input
              value={avatarUrl}
              onChange={(e) => setAvatarUrl(e.target.value)}
              required
            />
          </div>
          <div>
            <Label>Modèle</Label>
            <Input value={model} onChange={(e) => setModel(e.target.value)} />
          </div>
          <Button type="submit">Ajouter</Button>
          {message && <p className="text-sm mt-2 text-center">{message}</p>}
        </form>
      </CardContent>
    </Card>
  );
}

import React, { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import type { AI } from "@/types";

interface Props {
  onEdit: (ai: AI) => void;
}

export default function AIList({ onEdit }: Props) {
  const [ais, setAIs] = useState<AI[]>([]);

  const fetchAIs = async () => {
    try {
      const res = await fetch("http://localhost:8000/api/admin/list-ai");
      const data = await res.json();
      setAIs(data);
    } catch (error) {
      console.error("Erreur lors du chargement des IA :", error);
    }
  };

  const handleDelete = async (id: string) => {
    const confirmDelete = window.confirm("Supprimer cette IA ?");
    if (!confirmDelete) return;

    try {
      const res = await fetch(`http://localhost:8000/api/admin/delete-ai/${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        setAIs(ais.filter((ai) => ai.id !== id));
      }
    } catch (error) {
      console.error("Erreur lors de la suppression :", error);
    }
  };

  useEffect(() => {
    fetchAIs();
  }, []);

  return (
    <div className="grid gap-4">
      {ais.map((ai) => (
        <Card key={ai.id}>
          <CardContent className="p-4 flex justify-between items-center">
            <div>
              <h3 className="font-bold">{ai.name}</h3>
              <p className="text-sm text-muted-foreground">{ai.description}</p>
              <p className="text-xs text-muted-foreground italic">{ai.model}</p>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" onClick={() => onEdit(ai)}>Modifier</Button>
              <Button variant="destructive" onClick={() => handleDelete(ai.id)}>Supprimer</Button>
            </div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}


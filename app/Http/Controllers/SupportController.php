<?php

namespace App\Http\Controllers;

use App\Models\support;
use Illuminate\Http\Request;
use Exception;

class SupportController extends Controller
{
    public function Support(Request $request)
    {
        try {
            // Validation des données reçues
            $validatedData = $request->validate([
                'email' => 'required|email',
                'date' => 'required|date',
                'immatriculation' => 'required|string',
                'probleme' => 'required|string',
                'tel' => 'required|string',
            ]);

            // Création d'un nouvel enregistrement
            $post = new Support();
            $post->email = $validatedData['email'];
            $post->date = $validatedData['date'];
            $post->immatriculation = $validatedData['immatriculation'];
            $post->probleme = $validatedData['probleme'];
            $post->tel = $validatedData['tel'];
            $post->save();

            return response()->json([
                'status_code' => 200,
                'status_message' => 'Le post a été ajouté avec succès',
                'data' => $post
            ], 200);
        } catch (Exception $e) {
            return response()->json([
                'status_code' => 500,
                'status_message' => 'Une erreur est survenue',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function read()
    {
        // Récupérer les interventions avec les colonnes spécifiées
        $post = support::all(['id', 'email', 'tel', 'immatriculation', 'date', 'probleme']);

        // Retourner les données sous forme de JSON
        return response()->json($post); // Retourne les données sous forme de JSON
    }


    public function delete($id)
    {
        $post = support::find($id);

        if ($post) {
            $post->delete();
            return response()->json(['message' => 'Intervention resolved successfully']);
        }

        return response()->json(['message' => 'Intervention not found'], 404);
    }


}

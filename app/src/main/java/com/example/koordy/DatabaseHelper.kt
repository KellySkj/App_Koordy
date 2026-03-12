package com.example.koordy

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues

class DatabaseHelper(context: Context) :
    SQLiteOpenHelper(context, "koordy.db", null, 1) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(CREATE_ASSOCIATION)
        db.execSQL(CREATE_MEMBRE)
        db.execSQL(CREATE_EQUIPE)
        db.execSQL(CREATE_EVENEMENT)
        db.execSQL(CREATE_ACTUALITE)
        db.execSQL(CREATE_PARTICIPATION)

    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS association")
        db.execSQL("DROP TABLE IF EXISTS membre")

        onCreate(db)

    }

    private val CREATE_ASSOCIATION = """
CREATE TABLE association(
id_association INTEGER PRIMARY KEY AUTOINCREMENT,
nom TEXT,
type_structure TEXT,
sport TEXT,
adresse TEXT,
adresse_2 TEXT,
description TEXT,
date_creation TEXT,
image TEXT,
code_postal INTEGER,
ville TEXT,
pays TEXT,
couleur_1 TEXT,
couleur_2 TEXT
)
"""

    private val CREATE_MEMBRE = """
CREATE TABLE membre(
id_membre INTEGER PRIMARY KEY AUTOINCREMENT,
nom_membre TEXT,
prenom_membre TEXT,
mail_membre TEXT,
password_membre TEXT,
date_naissance TEXT,
age INTEGER
)
"""
    private val CREATE_EQUIPE = """
CREATE TABLE equipe(
id_equipe INTEGER PRIMARY KEY AUTOINCREMENT,
nom_equipe TEXT,
description_equipe TEXT,
categorie TEXT
)
"""

    private val CREATE_EVENEMENT = """
CREATE TABLE evenement(
id_evenement INTEGER PRIMARY KEY AUTOINCREMENT,
titre_evenement TEXT,
description_evenement TEXT,
type_evenement TEXT,
date_debut_event TEXT,
date_fin_event TEXT,
lieu_event TEXT,
id_association INTEGER
)
"""

    private val CREATE_ACTUALITE = """
CREATE TABLE actualite(
id_actualite INTEGER PRIMARY KEY AUTOINCREMENT,
id_association INTEGER,
id_auteur INTEGER,
type_actualite TEXT,
titre TEXT,
contenu TEXT,
image_principale TEXT,
date_creation TEXT,
date_publication TEXT,
statut TEXT,
id_evenement INTEGER,
event_date TEXT
)
"""
    private val CREATE_PARTICIPATION = """
CREATE TABLE participation(
id_participation INTEGER PRIMARY KEY AUTOINCREMENT,
id_evenement INTEGER,
id_membre INTEGER,
presence TEXT
)
"""

    fun addMembre(nom: String, prenom: String){

        val db = this.writableDatabase

        val values = ContentValues()

        values.put("nom_membre", nom)
        values.put("prenom_membre", prenom)

        db.insert("membre", null, values)

        db.close()

    }

    fun getMembres(): List<String>{

        val list = mutableListOf<String>()

        val db = this.readableDatabase

        val cursor = db.rawQuery("SELECT nom_membre FROM membre", null)

        if(cursor.moveToFirst()){
            do{
                list.add(cursor.getString(0))
            }while(cursor.moveToNext())
        }

        cursor.close()

        return list

    }




}
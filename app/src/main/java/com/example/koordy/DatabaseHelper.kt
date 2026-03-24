package com.example.koordy

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

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
        db.execSQL("DROP TABLE IF EXISTS equipe")
        db.execSQL("DROP TABLE IF EXISTS evenement")
        db.execSQL("DROP TABLE IF EXISTS actualite")
        db.execSQL("DROP TABLE IF EXISTS participation")
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

    fun addMembre(nom: String, prenom: String, mail: String, password: String, dateNaissance: String, age: Int): Long {
        val db = this.writableDatabase
        val values = ContentValues()
        values.put("nom_membre", nom)
        values.put("prenom_membre", prenom)
        values.put("mail_membre", mail)
        values.put("password_membre", password)
        values.put("date_naissance", dateNaissance)
        values.put("age", age)

        val id = db.insert("membre", null, values)
        db.close()
        return id
    }

    fun checkUser(email: String, password: String): Boolean {
        val db = this.readableDatabase
        val query = "SELECT * FROM membre WHERE mail_membre = ? AND password_membre = ?"
        val cursor = db.rawQuery(query, arrayOf(email, password))
        val exists = cursor.count > 0
        cursor.close()
        db.close()
        return exists
    }

    fun addAssociation(
        nom: String,
        type: String,
        sport: String,
        adresse: String,
        adresse2: String?,
        cp: Int,
        ville: String,
        pays: String,
        desc: String?,
        date: String
    ): Long {
        val db = this.writableDatabase
        val values = ContentValues()
        values.put("nom", nom)
        values.put("type_structure", type)
        values.put("sport", sport)
        values.put("adresse", adresse)
        values.put("adresse_2", adresse2)
        values.put("code_postal", cp)
        values.put("ville", ville)
        values.put("pays", pays)
        values.put("description", desc)
        values.put("date_creation", date)

        val id = db.insert("association", null, values)
        db.close()
        return id
    }

    fun searchAssociation(nom: String): Cursor {
        val db = this.readableDatabase
        return db.rawQuery("SELECT * FROM association WHERE nom LIKE ?", arrayOf("%$nom%"))
    }
}

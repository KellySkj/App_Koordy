package com.example.koordy

import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.Button
import android.widget.Toast
import com.google.android.material.textfield.TextInputEditText

class CreateAssociationActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.create_association_page)

        setupToolbar()

        val dbHelper = DatabaseHelper(this)

        val types = arrayOf("Club", "Association", "Académie", "Autre")
        val adapter = ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, types)
        val spinnerType = findViewById<AutoCompleteTextView>(R.id.spinner_type)
        spinnerType.setAdapter(adapter)

        val etNom = findViewById<TextInputEditText>(R.id.et_asso_nom)
        val etSport = findViewById<TextInputEditText>(R.id.et_asso_sport)
        val etAdresse = findViewById<TextInputEditText>(R.id.et_asso_adresse)
        val etAdresse2 = findViewById<TextInputEditText>(R.id.et_asso_adresse2)
        val etCp = findViewById<TextInputEditText>(R.id.et_asso_cp)
        val etVille = findViewById<TextInputEditText>(R.id.et_asso_ville)
        val etPays = findViewById<TextInputEditText>(R.id.et_asso_pays)
        val etDesc = findViewById<TextInputEditText>(R.id.et_asso_desc)
        val etDate = findViewById<TextInputEditText>(R.id.et_asso_date)
        val btnNext = findViewById<Button>(R.id.btn_asso_next)

        btnNext.setOnClickListener {
            val nom = etNom.text.toString()
            val type = spinnerType.text.toString()
            val sport = etSport.text.toString()
            val adresse = etAdresse.text.toString()
            val adresse2 = etAdresse2.text.toString()
            val cpStr = etCp.text.toString()
            val ville = etVille.text.toString()
            val pays = etPays.text.toString()
            val desc = etDesc.text.toString()
            val date = etDate.text.toString()

            if (nom.isNotEmpty() && type.isNotEmpty() && sport.isNotEmpty() && 
                adresse.isNotEmpty() && cpStr.isNotEmpty() && ville.isNotEmpty() && 
                pays.isNotEmpty() && date.isNotEmpty()) {
                
                val cp = cpStr.toIntOrNull() ?: 0
                val id = dbHelper.addAssociation(nom, type, sport, adresse, adresse2, cp, ville, pays, desc, date)
                
                if (id != -1L) {
                    Toast.makeText(this, "Association créée avec succès !", Toast.LENGTH_SHORT).show()
                    finish()
                } else {
                    Toast.makeText(this, "Erreur lors de la création", Toast.LENGTH_SHORT).show()
                }
            } else {
                Toast.makeText(this, "Veuillez remplir tous les champs obligatoires (*)", Toast.LENGTH_SHORT).show()
            }
        }
    }
}

package com.example.koordy

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import com.google.android.material.textfield.TextInputEditText

class SignupActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.signup_page)

        setupToolbar()

        val customMessage = intent.getStringExtra("EXTRA_MESSAGE")
        if (customMessage != null) {
            val tvHeroTitle = findViewById<TextView>(R.id.signup_hero_title)
            tvHeroTitle?.text = customMessage
        }

        val dbHelper = DatabaseHelper(this)

        val etNom = findViewById<TextInputEditText>(R.id.et_nom)
        val etPrenom = findViewById<TextInputEditText>(R.id.et_prenom)
        val etEmail = findViewById<TextInputEditText>(R.id.et_email)
        val etPassword = findViewById<TextInputEditText>(R.id.et_password)
        val etDateNaissance = findViewById<TextInputEditText>(R.id.et_date_naissance)
        val etAge = findViewById<TextInputEditText>(R.id.et_age)
        val btnSignup = findViewById<Button>(R.id.btn_signup)

        btnSignup.setOnClickListener {
            val nom = etNom.text.toString()
            val prenom = etPrenom.text.toString()
            val email = etEmail.text.toString()
            val password = etPassword.text.toString()
            val dateNaissance = etDateNaissance.text.toString()
            val ageStr = etAge.text.toString()

            if (nom.isNotEmpty() && prenom.isNotEmpty() && email.isNotEmpty() && password.isNotEmpty()) {
                val age = ageStr.toIntOrNull() ?: 0
                
                val id = dbHelper.addMembre(nom, prenom, email, password, dateNaissance, age)
                if (id != -1L) {
                    Toast.makeText(this, "Inscription réussie !", Toast.LENGTH_SHORT).show()
                    val intent = Intent(this, ChoiceAssociationActivity::class.java)
                    startActivity(intent)
                    finish()
                } else {
                    Toast.makeText(this, "Erreur lors de l'inscription", Toast.LENGTH_SHORT).show()
                }
            } else {
                Toast.makeText(this, "Veuillez remplir tous les champs obligatoires", Toast.LENGTH_SHORT).show()
            }
        }
    }
}

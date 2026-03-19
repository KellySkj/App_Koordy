package com.example.koordy

import android.content.Intent
import android.os.Bundle
import android.widget.Button

class MainActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.home_page)

        // Configuration de la toolbar via BaseActivity
        setupToolbar()

        // Configuration du bouton d'inscription principal (Hero)
        val heroCtaBtn = findViewById<Button>(R.id.hero_cta)
        heroCtaBtn?.setOnClickListener {
            val intent = Intent(this, SignupActivity::class.java)
            intent.putExtra("EXTRA_MESSAGE", "Créez votre compte pour inscrire votre association")
            startActivity(intent)
        }
    }
}

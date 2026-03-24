package com.example.koordy

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.constraintlayout.helper.widget.Carousel


class MainActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        enableEdgeToEdge()
        setContentView(R.layout.home_page)

        val banner = findViewById<android.view.View>(R.id.announcement_banner)
        ViewCompat.setOnApplyWindowInsetsListener(banner) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(v.paddingLeft, systemBars.top, v.paddingRight, v.paddingBottom)
            insets
        }
        // Initialisation du Carousel

        // Configuration du bouton d'inscription principal (Hero)
        val heroCtaBtn = findViewById<Button>(R.id.hero_cta)
        heroCtaBtn?.setOnClickListener {
            val intent = Intent(this, SignupActivity::class.java)
            intent.putExtra("EXTRA_MESSAGE", "Créez votre compte pour inscrire votre association")
            startActivity(intent)
        }
    }
}

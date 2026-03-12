package com.example.koordy

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Active le mode bord à bord
        enableEdgeToEdge()
        
        setContentView(R.layout.home_page)

        // On applique le padding système au bandeau d'annonce pour ne pas être sous l'encoche
        val banner = findViewById<android.view.View>(R.id.announcement_banner)
        ViewCompat.setOnApplyWindowInsetsListener(banner) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(v.paddingLeft, systemBars.top, v.paddingRight, v.paddingBottom)
            insets
        }
    }
}

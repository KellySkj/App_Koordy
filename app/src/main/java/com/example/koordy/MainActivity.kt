package com.example.koordy

import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.constraintlayout.helper.widget.Carousel

class MainActivity : AppCompatActivity() {

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

        val btnConnexion = findViewById<Button>(R.id.btn_connexion)
        btnConnexion.setOnClickListener {
            Toast.makeText(this, "Redirection vers la connexion...", Toast.LENGTH_SHORT).show()

        }}}

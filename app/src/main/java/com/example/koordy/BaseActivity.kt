package com.example.koordy

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity

open class BaseActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
    }

    protected fun setupToolbar() {
        // Logo et Titre -> Accueil
        findViewById<ImageView>(R.id.toolbar_logo)?.setOnClickListener {
            goToHome()
        }
        findViewById<TextView>(R.id.toolbar_title)?.setOnClickListener {
            goToHome()
        }

        // Boutons de navigation
        /*findViewById<Button>(R.id.toolbar_btn1)?.setOnClickListener {
            goToHome()
        }
        findViewById<Button>(R.id.toolbar_btn2)?.setOnClickListener {
            Toast.makeText(this, "Section Témoignages bientôt disponible", Toast.LENGTH_SHORT).show()
        }
        findViewById<Button>(R.id.toolbar_btn3)?.setOnClickListener {
            Toast.makeText(this, "Koordy+ bientôt disponible", Toast.LENGTH_SHORT).show()
        }
*/
        // Boutons d'authentification
        findViewById<Button>(R.id.btn_connexion)?.setOnClickListener {
            if (this !is LoginActivity) {
                val intent = Intent(this, LoginActivity::class.java)
                startActivity(intent)
            }
        }

       /* findViewById<Button>(R.id.toolbar_signup_btn)?.setOnClickListener {
            if (this !is SignupActivity) {
                val intent = Intent(this, SignupActivity::class.java)
                intent.putExtra("EXTRA_MESSAGE", "Créez votre compte")
                startActivity(intent)
            }
        }*/
    }

    private fun goToHome() {
        if (this !is MainActivity) {
            val intent = Intent(this, MainActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
            startActivity(intent)
        }
    }
}

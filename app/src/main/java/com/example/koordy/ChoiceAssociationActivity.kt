package com.example.koordy

import android.content.Intent
import android.os.Bundle
import com.google.android.material.card.MaterialCardView

class ChoiceAssociationActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.choice_association_page)

        setupToolbar()

        val cardCreate = findViewById<MaterialCardView>(R.id.card_create_asso)
        val cardSearch = findViewById<MaterialCardView>(R.id.card_search_asso)

        cardCreate.setOnClickListener {
            val intent = Intent(this, CreateAssociationActivity::class.java)
            startActivity(intent)
        }

        cardSearch.setOnClickListener {
            val intent = Intent(this, SearchAssociationActivity::class.java)
            startActivity(intent)
        }
    }
}

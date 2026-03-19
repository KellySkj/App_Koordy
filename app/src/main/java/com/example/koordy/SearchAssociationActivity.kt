package com.example.koordy

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.textfield.TextInputEditText

class SearchAssociationActivity : BaseActivity() {

    private lateinit var dbHelper: DatabaseHelper
    private lateinit var adapter: AssociationAdapter
    private val associationList = mutableListOf<Association>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.search_association_page)

        setupToolbar()

        dbHelper = DatabaseHelper(this)

        val etSearchInput = findViewById<TextInputEditText>(R.id.et_search_input)
        val btnSearchGo = findViewById<Button>(R.id.btn_search_go)
        val rvResults = findViewById<RecyclerView>(R.id.rv_search_results)

        adapter = AssociationAdapter(associationList) { asso ->
            Toast.makeText(this, "Association sélectionnée : ${asso.nom}", Toast.LENGTH_SHORT).show()
        }

        rvResults.layoutManager = LinearLayoutManager(this)
        rvResults.adapter = adapter

        btnSearchGo.setOnClickListener {
            val query = etSearchInput.text.toString().trim()
            if (query.isNotEmpty()) {
                performSearch(query)
            } else {
                Toast.makeText(this, "Veuillez saisir un nom", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun performSearch(query: String) {
        associationList.clear()
        val cursor = dbHelper.searchAssociation(query)
        
        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getLong(cursor.getColumnIndexOrThrow("id_association"))
                val nom = cursor.getString(cursor.getColumnIndexOrThrow("nom"))
                val type = cursor.getString(cursor.getColumnIndexOrThrow("type_structure"))
                val sport = cursor.getString(cursor.getColumnIndexOrThrow("sport"))
                val ville = cursor.getString(cursor.getColumnIndexOrThrow("ville"))
                
                associationList.add(Association(id, nom, type, sport, ville))
            } while (cursor.moveToNext())
        }
        cursor.close()

        if (associationList.isEmpty()) {
            Toast.makeText(this, "Aucune association trouvée", Toast.LENGTH_SHORT).show()
        }
        adapter.notifyDataSetChanged()
    }

    data class Association(val id: Long, val nom: String, val type: String, val sport: String, val ville: String)

    class AssociationAdapter(
        private val list: List<Association>,
        private val onClick: (Association) -> Unit
    ) : RecyclerView.Adapter<AssociationAdapter.ViewHolder>() {

        class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            val tvNom: TextView = view.findViewById(android.R.id.text1)
            val tvDetails: TextView = view.findViewById(android.R.id.text2)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context)
                .inflate(android.R.layout.simple_list_item_2, parent, false)
            return ViewHolder(view)
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            val item = list[position]
            holder.tvNom.text = item.nom
            holder.tvDetails.text = "${item.type} — ${item.sport} — ${item.ville}"
            holder.itemView.setOnClickListener { onClick(item) }
        }

        override fun getItemCount() = list.size
    }
}

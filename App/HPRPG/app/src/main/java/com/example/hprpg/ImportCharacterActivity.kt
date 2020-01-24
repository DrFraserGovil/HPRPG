package com.example.hprpg

import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Spinner
import android.widget.TextView
import android.widget.AdapterView
import androidx.core.app.ComponentActivity
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T



class ImportCharacterActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_import_character)

        val species = resources.getStringArray(R.array.species)
        val spinner = findViewById<Spinner>(R.id.spinner)
        spinner.setPrompt("Hey")

        val adapter = ArrayAdapter(this,
            android.R.layout.simple_spinner_item, species)
        spinner.adapter = adapter


        spinner.setOnItemSelectedListener(object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(
                parent: AdapterView<*>,
                view: View,
                position: Int,
                id: Long
            ) {
                (view as TextView).setTextColor(Color.WHITE) //Change selected text color
            }

            override fun onNothingSelected(parent: AdapterView<*>) {

            }
        })
    }
}

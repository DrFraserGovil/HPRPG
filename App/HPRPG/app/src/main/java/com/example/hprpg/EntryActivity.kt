package com.example.hprpg

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View

class EntryActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_entry)
    }

    fun initiateCreation(view: View){
        val intent = Intent(this,CreateCharacterActivity::class.java).apply{}
        startActivity(intent)
    }
}

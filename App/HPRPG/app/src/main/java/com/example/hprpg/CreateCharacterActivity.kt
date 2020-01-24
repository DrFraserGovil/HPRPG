package com.example.hprpg

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View

class CreateCharacterActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_create_character)
    }




    fun initiateImport(view: View){
        val intent = Intent(this,ImportCharacterActivity::class.java).apply{}
        startActivity(intent)
    }
}

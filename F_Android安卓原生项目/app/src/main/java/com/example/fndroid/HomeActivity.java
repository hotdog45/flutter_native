package com.example.fndroid;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;

import io.flutter.facade.Flutter;

public class HomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
        tx.replace(R.id.rl_root_view, Flutter.createFragment("route1"));
        tx.commit();

    }

}

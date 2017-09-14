package com.aadimator.android.paktext;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Environment;
import android.support.constraint.ConstraintLayout;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import butterknife.BindArray;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static java.security.AccessController.getContext;

public class MainActivity extends AppCompatActivity {

    private List<Integer> textSizes = new ArrayList<>(Arrays.asList(16, 18, 22, 28, 32, 36, 48));
    private int currentTextSize;

    @BindView(R.id.editText)
    EditText mEditText;

    @BindView(R.id.pictureView)
    ConstraintLayout mPictureView;

    @BindArray(R.array.backgroundColors)
    int[] backgroundColors;

    @OnClick(R.id.imageButtonChangeColor)
    void changeColor(View view) {
        int color = backgroundColors[new Random().nextInt(backgroundColors.length)];

        ConstraintLayout rootView = (ConstraintLayout) findViewById(R.id.rootView);
        rootView.setBackgroundColor(color);
        mPictureView.setBackgroundColor(color);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(color);
        }
    }

    @OnClick(R.id.imageButtonTextSize)
    void changeTextSize(View view) {
        int index = textSizes.indexOf(currentTextSize);
        index++;
        if (index >= textSizes.size()) index = 0;

        currentTextSize = textSizes.get(index);
        mEditText.setTextSize(currentTextSize);
    }

    @OnClick(R.id.imageButtonChangeAlignment)
    void changeAlignment(ImageButton view) {
        int alignment = mEditText.getTextAlignment();
        if (alignment == View.TEXT_ALIGNMENT_CENTER) {
            mEditText.setTextAlignment(View.TEXT_ALIGNMENT_TEXT_START);
            view.setImageResource(R.drawable.ic_format_align_center);
        } else {
            mEditText.setTextAlignment(View.TEXT_ALIGNMENT_CENTER);
            view.setImageResource(R.drawable.ic_format_align_right);
        }
    }

    @OnClick(R.id.imageButtonSaveImage)
    void saveImage(ImageButton view) {
        mPictureView.setDrawingCacheEnabled(true);
        Bitmap bitmap = mPictureView.getDrawingCache();

        File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), "test.png");

        try {
            bitmap.compress(Bitmap.CompressFormat.PNG, 95, new FileOutputStream(file));
            Log.v("SAVE_IMAGE", "File saved to : " + file.getAbsolutePath());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);

        Typeface typeface = Typeface.createFromAsset(getAssets(), "fonts/jameel-noori-nastaleeq-regular.ttf");
        mEditText.setTypeface(typeface);

        currentTextSize = textSizes.get(textSizes.size() - 1);
        mEditText.setTextSize(currentTextSize);

    }
}

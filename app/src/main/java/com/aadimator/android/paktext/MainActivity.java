package com.aadimator.android.paktext;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Random;

import butterknife.BindArray;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnLongClick;

public class MainActivity extends AppCompatActivity {

    @BindView(R.id.editText)
    EditText mEditText;

    @BindView(R.id.pictureView)
    ConstraintLayout mPictureView;

    @BindArray(R.array.fontSize)
    int[] textSizes;

    private int currentTextSize = 0;

    @BindArray(R.array.backgroundColors)
    int[] backgroundColors;

    private int currentColor = 0;

    @BindArray(R.array.fonts)
    String[] fonts;

    private int currentFont = 0;

    @OnLongClick(R.id.imageButtonChangeColor)
    boolean previousColor(View view){
        if (currentColor == 0) currentColor = backgroundColors.length;
        currentColor -= 2;
        changeColor(view);
        return true;
    }

    @OnClick(R.id.imageButtonChangeColor)
    void changeColor(View view) {
        currentColor++;
        if (currentColor >= backgroundColors.length) currentColor = 0;
        int color = backgroundColors[currentColor];

        ConstraintLayout rootView = (ConstraintLayout) findViewById(R.id.rootView);
        rootView.setBackgroundColor(color);
        mPictureView.setBackgroundColor(color);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(color);
        }
    }

    @OnClick(R.id.imageButtonFontChange)
    void changeFont(View view) {
        currentFont++;
        if (currentFont >= fonts.length) currentFont = 0;
        String path = fonts[currentFont];

        Typeface typeface = Typeface.createFromAsset(getAssets(), path);
        mEditText.setTypeface(typeface);

        Log.d("FontInfo", path);
    }

    @OnLongClick(R.id.imageButtonTextSize)
    boolean previousSize(View view){
        if (currentTextSize == 0) currentTextSize = textSizes.length;
        currentTextSize -= 2;
        changeTextSize(view);
        return true;
    }

    @OnClick(R.id.imageButtonTextSize)
    void changeTextSize(View view) {
        currentTextSize++;
        if (currentTextSize >= textSizes.length) currentTextSize = 0;

        int size = textSizes[currentTextSize];
        mEditText.setTextSize(size);
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
    void saveImage(View view) {
        Bitmap bitmap = Bitmap.createBitmap(
                mPictureView.getWidth(),
                mPictureView.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        mEditText.setCursorVisible(false);
        mPictureView.draw(canvas);

        String fileName = new SimpleDateFormat("yyyyMMddHHmmss'.png'").format(new Date());
        File file = new File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                fileName
        );

        try {
            bitmap.compress(Bitmap.CompressFormat.PNG, 95, new FileOutputStream(file));
            Toast.makeText(MainActivity.this, "Saved !!!", Toast.LENGTH_SHORT).show();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        mEditText.setCursorVisible(true);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);

        changeFont(mPictureView);
        changeTextSize(mPictureView);



    }
}

package com.aadimator.android.paktext.utilities;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

/**
 * Created by Aadam on 9/14/2017.
 */

public class UrduTextView extends android.support.v7.widget.AppCompatTextView {
    public UrduTextView(Context context) {
        super(context);
        setFont();
    }

    public UrduTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setFont();
    }

    public UrduTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setFont();
    }

    private void setFont() {
        Typeface font = Typeface.createFromAsset(getContext().getAssets(), "fonts/jameel-noori-nastaleeq-regular.ttf");
        setTypeface(font, Typeface.NORMAL);
    }
}

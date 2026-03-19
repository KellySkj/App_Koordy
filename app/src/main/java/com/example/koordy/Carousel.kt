package com.example.koordy

import android.view.View
import android.widget.ImageView
import androidx.constraintlayout.helper.widget.Carousel

fun setupCarousel(carousel: Carousel) {
    val images = intArrayOf(
        R.drawable.image_asso0,
        R.drawable.image_asso1,
        R.drawable.image_asso2,
        R.drawable.image_asso3
    )

    carousel.setAdapter(object : Carousel.Adapter {
        override fun count(): Int {
            return images.size
        }

        override fun populate(view: View, index: Int) {
            if (view is ImageView) {
                view.setImageResource(images[index])
            }
        }

        override fun onNewItem(index: Int) {
            // Optionnel : Action lors du changement d'image
        }
    })
}

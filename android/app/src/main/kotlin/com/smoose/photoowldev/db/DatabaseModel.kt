package com.smoose.photoowldev.db

import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.RoomDatabase

@Entity
data class Images (
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "image_id")
    val imageId: Int = 0,
    val path: String,
    val owner: String,
    @ColumnInfo(name = "unix_timestamp") val unixTimestamp: Long?,
    @ColumnInfo(name = "is_uploading") val isUploading: Int,
    @ColumnInfo(name = "is_uploaded") val isUploaded: Int,
)

@Dao
interface ImagesDao {
    @Query("SELECT * FROM Images ORDER BY unix_timestamp DESC LIMIT 1")
    fun lastAdded(): Images

    @Insert
    fun insertAll(vararg images: Images)
}

@Database(entities = [Images::class], version = 1)
abstract class ImagesDB: RoomDatabase() {
    abstract fun imagesDao(): ImagesDao
}

package com.smoose.photoowldev

import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.RoomDatabase

@Entity
data class Images (
    @ColumnInfo(name = "path") val path: String,
    @ColumnInfo(name = "unix_timestamp") val unixTimestamp: Long?,
    @ColumnInfo(name = "is_uploading") val isUploading: Int?,
    @ColumnInfo(name = "is_uploaded") val isUploaded: Int?,
    @ColumnInfo(name = "owner") val owner: String?,
)

@Dao
interface ImagesDao {
    @Insert
    fun insertAll(vararg images: Images)
}

@Database(entities = [Images::class], version = 1)
abstract class ImagesDB: RoomDatabase() {
    abstract fun imagesDao(): ImagesDao
}

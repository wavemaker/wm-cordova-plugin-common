/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package com.wavemaker.cordova.plugin;

import android.content.Context;
import android.util.Log;
import android.webkit.MimeTypeMap;
import android.webkit.WebResourceResponse;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.webkit.WebViewAssetLoader;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;

public class FilePathHandler implements WebViewAssetLoader.PathHandler{

    private static final String ASSET_PREFIX = "_app_file_";
    private static final String WWW_PREFIX = "_www";
    private static final String INDEX_HTML = "index.html";

    private Context context;
    private boolean prefixToWWWFiles = true;

    FilePathHandler(Context context, boolean prefixToWWWFiles) {
        this.context = context;
        this.prefixToWWWFiles = prefixToWWWFiles;
    }

    @Nullable
    @Override
    public WebResourceResponse handle(@NonNull String path) {
        try {
            if (path.startsWith(ASSET_PREFIX)) {
                String filePath = path.substring(path.indexOf(ASSET_PREFIX) + ASSET_PREFIX.length());
                String extension = MimeTypeMap.getFileExtensionFromUrl(filePath);
                FileInputStream is = new FileInputStream(filePath);
                String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
                return new WebResourceResponse(mimeType, null, is);
            } else if (this.prefixToWWWFiles && path.startsWith(WWW_PREFIX)){
                String extension = MimeTypeMap.getFileExtensionFromUrl(path);
                InputStream is = this.context.getAssets().open("www"
                        + path.substring(path.indexOf(WWW_PREFIX)
                        + WWW_PREFIX.length()));;
                String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
                return new WebResourceResponse(mimeType, null, is);
            } else if (this.prefixToWWWFiles && path.startsWith(INDEX_HTML)) {
                String extension = MimeTypeMap.getFileExtensionFromUrl(path);
                String content = MessageFormat.format("<script>location.href=\"{0}/index.html\"</script>", WWW_PREFIX);
                InputStream is = new ByteArrayInputStream(content.getBytes(StandardCharsets.UTF_8));
                String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
                return new WebResourceResponse(mimeType, null, is);
            }
        } catch (Exception e) {
            Log.e("FilePathHandler", "", e);
        }
        return null;
    }
}

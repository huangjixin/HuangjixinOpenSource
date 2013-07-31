package com.bingya.domain.system;

import java.io.Serializable;

public class Comment implements Serializable {
    private String id;

    private String content;

    private String tbArticleId;

    private String parentid;

    private static final long serialVersionUID = 1L;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }

    public String getTbArticleId() {
        return tbArticleId;
    }

    public void setTbArticleId(String tbArticleId) {
        this.tbArticleId = tbArticleId == null ? null : tbArticleId.trim();
    }

    public String getParentid() {
        return parentid;
    }

    public void setParentid(String parentid) {
        this.parentid = parentid == null ? null : parentid.trim();
    }
}
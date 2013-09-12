package com.bingya.domain.system;

import java.io.Serializable;

public class Comment implements Serializable {
    private Integer id;

    private String content;

    private Integer tbArticleId;

    private Integer parentid;

    private static final long serialVersionUID = 1L;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }

    public Integer getTbArticleId() {
        return tbArticleId;
    }

    public void setTbArticleId(Integer tbArticleId) {
        this.tbArticleId = tbArticleId;
    }

    public Integer getParentid() {
        return parentid;
    }

    public void setParentid(Integer parentid) {
        this.parentid = parentid;
    }
}
#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QtGlobal>
#include <unordered_map>
#include <vector>

class ProcessModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int page READ page NOTIFY pageChanged)
    Q_PROPERTY(int totalPages READ totalPages NOTIFY totalPagesChanged)
    Q_PROPERTY(int pageSize READ pageSize WRITE setPageSize NOTIFY pageSizeChanged)

public:
    enum Roles {
        PidRole = Qt::UserRole + 1,
        NameRole,
        CpuRole,
        MemoryRole,
        ThreadsRole,
        VoluntaryCsRole,
        NonVoluntaryCsRole
    };

    static ProcessModel *instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    int page() const;
    int totalPages() const;
    int pageSize() const;

    void setPageSize(int value);

    Q_INVOKABLE void refresh();
    Q_INVOKABLE void nextPage();
    Q_INVOKABLE void prevPage();
    Q_INVOKABLE void gotoPage(int page);

signals:
    void pageChanged();
    void totalPagesChanged();
    void pageSizeChanged();

private:
    struct ProcessEntry {
        int pid = 0;
        QString name;
        double cpuPercent = 0.0;
        double memoryMb = 0.0;
        int threads = 0;
        qint64 voluntaryCs = 0;
        qint64 nonVoluntaryCs = 0;
    };

    explicit ProcessModel(QObject *parent = nullptr);

    void setPageInternal(int newPage);
    std::vector<ProcessEntry> collectProcesses(long long &currTotalJiffies,
                                               std::unordered_map<int, long long> &currTimes) const;

    std::vector<ProcessEntry> m_processes;
    std::unordered_map<int, long long> m_prevProcTimes;
    long long m_prevTotalJiffies = 0;
    int m_page = 0;
    int m_pageSize = 25;
};

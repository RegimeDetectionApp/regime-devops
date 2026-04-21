FROM regime-base:latest AS base

USER root
RUN pip install --no-cache-dir yfinance>=0.2.30 \
    regime-market-data@git+https://github.com/RegimeDetectionApp/regime-market-data.git@main
USER appuser

COPY --chown=appuser:appuser services/market_data/ /app/services/market_data/
EXPOSE 7001
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD python -c "import httpx; httpx.get('http://localhost:7001/health').raise_for_status()"
CMD ["uvicorn", "services.market_data.app:app", "--host", "0.0.0.0", "--port", "7001"]
